//
//  MainVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit
import RxSwift

class MainVC: BaseVC {
    
    lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.barTintColor = .myRed.withAlphaComponent(0.6)
        searchBar.tintColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Someting", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        searchBar.searchTextField.textColor = .white
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.width
        var layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 16
        let cellWidth = (width - 70) / 2
        layout.itemSize = CGSize(width: cellWidth, height: height/1.9)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .myGray
        collectionView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "foodCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var foodList = [Yemekler]()
    var cartList = [Sepet_yemekler]()
    var favoriteList = [Food]()
    var viewModel = MainViewModel()
    
    override func setupViews() {
        super.setupViews()
        
        viewModel.getAllFood(completion: { value in })
        viewModel.getCartFood()
        viewModel.getFavorites()
        bindViewModel()
        setNavbar()
        
        hideKeyboardWhenTappedAround()
        view.addSubview(containerView)
        containerView.addSubviews([searchBar, collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCartFood()
    }
    
    func setNavbar() {
        self.navigationItem.title = "Foods"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .myRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Rubik-Medium", size: 22)!]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func bindViewModel() {
        _ = viewModel.foodList.subscribe { foods in
            self.foodList = foods
            self.reload()
        }
        
        _ = viewModel.cartList.subscribe { foods in
            self.cartList = foods
            self.reload()
        }
        
        _ = viewModel.favoriteList.subscribe { foods in
            self.favoriteList = foods
            self.reload()
        }
    }
    
    func addFoodToCart(yemekID: String, addCount: Int = 1, completion: @escaping (Bool) -> ()) {
        if let currentFood = foodList.filter({$0.yemekID == yemekID}).first {
            viewModel.addToCart(yemek: currentFood, addCount: addCount, completion: { value in
                completion(value)
            })
        }
    }
    
    func removeFoodToCart(yemekAdi: String, completion: @escaping (Bool) -> ()) {
        if let currentFood = cartList.filter({$0.yemekAdi == yemekAdi}).first {
            viewModel.removeFromCart(yemek: currentFood, completion: { value in
                completion(value)
            })
        }
    }
}

//MARK: CollectionView
extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionCell
        let food = foodList[indexPath.row]
        cell.delegate = self
        let cartFood = cartList.filter({$0.yemekAdi == food.yemekAdi}).first
        let favFood = favoriteList.filter({$0.id == food.yemekID}).first
        cell.configure(with: food, favYemek: favFood, cartCount: Int(cartFood?.yemekAdet ?? "0") ?? 0)
        cell.isFavorite = favoriteList.contains(where: { $0.id == food.yemekID })
        cell.setFav()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        let cartFood = cartList.filter({$0.yemekAdi == food.yemekAdi}).first
        let destination = DetailVC()
        destination.delegate = self
        let favFood = favoriteList.filter({$0.id == food.yemekID}).first
        destination.configureDetail(with: food, favYemek: favFood, count: Int(cartFood?.yemekAdet ?? "0") ?? 0)
        destination.isFavorite = favoriteList.contains(where: { $0.id == food.yemekID })
        destination.setFav()
        present(to: destination)
    }
}

//MARK: SearchBar
extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel.getAllFood(completion: {value in})
        } else {
            viewModel.foodList.onNext(foodList.filter{$0.yemekAdi!.lowercased().contains(searchText.lowercased())})
        }
    }
}

//MARK: Food CollectionCell Delegate
extension MainVC: FoodCollectionCellDelegate {
    
    func saveFavorite(yemek: Yemekler, completion: @escaping (Bool) -> ()) {
        if let id = yemek.yemekID, let name = yemek.yemekAdi, let imgName = yemek.yemekResimAdi, let price = yemek.yemekFiyat {
            viewModel.save(id: id, name: name, imageName: imgName, price: price, completion: { value in
                completion(value)
            })
        }
    }
    
    func deleteFavorite(food: Food, completion: @escaping (Bool) -> ()) {
        viewModel.delete(food: food, completion: { value in
            completion(value)
        })
        
    }
    
    func addCollectionFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {
        addFoodToCart(yemekID: yemekID) { value in
            completion(value)
        }
    }
    
    func removeCollectionFoodToCart(yemekAdi: String, completion: @escaping (Bool) -> ()) {
        removeFoodToCart(yemekAdi: yemekAdi) { value in
            completion(value)
        }
    }
}

//MARK: Detail Delegate
extension MainVC: DetailDelegate {
    func addFoodCart(yemekID: String, count: Int = 1, completion: @escaping (Bool) -> ()) {
        addFoodToCart(yemekID: yemekID, addCount: count) { value in
            completion(value)
        }
    }
    
    func removeFoodCart(yemekAdi: String, completion: @escaping (Bool) -> ()) {
        removeFoodToCart(yemekAdi: yemekAdi) { value in
            completion(value)
        }
    }
}

extension MainVC {
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
