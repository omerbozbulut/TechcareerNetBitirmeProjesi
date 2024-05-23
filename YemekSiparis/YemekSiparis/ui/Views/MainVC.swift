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
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        searchBar.placeholder = "Search someting"
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
    var viewModel = MainViewModel()
    
    override func setupViews() {
        super.setupViews()
        
        viewModel.getAllFood()
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
        viewModel.getAllFood()
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
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionCell
        let food = foodList[indexPath.row]
        cell.delegate = self
        let cartFood = cartList.filter({$0.yemekAdi == food.yemekAdi}).first
        cell.configure(with: food, cartCount: Int(cartFood?.yemekAdet ?? "0") ?? 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let food = foodList[indexPath.row]
       
        //navigationController?.pushViewController(generateVC, animated: true)
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension MainVC: FoodCollectionCellDelegate {
    func addFoodToCart(yemekID: String) {
        if let currentFood = foodList.filter({$0.yemekID == yemekID}).first {
            viewModel.addToCart(yemek: currentFood)
        }
    }
    
    func removeFoodToCart(yemekAdi: String) {
        if let currentFood = cartList.filter({$0.yemekAdi == yemekAdi}).first {
            viewModel.removeFromCart(yemek: currentFood)
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
