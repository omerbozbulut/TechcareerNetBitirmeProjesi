//
//  FavoritesVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit

class FavoritesVC: BaseVC {
    
    lazy var containerView: UIView = {
        return UIView()
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
        collectionView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "favFoodCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var foodList = [Food]()
    var viewModel = FavoritesViewModel()
    
    override func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        
        viewModel.getFavorites()
        bindViewModel()
        setNavbar()
    }
    
    func bindViewModel() {
        _ = viewModel.favoriteList.subscribe { foods in
            self.foodList = foods
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setNavbar() {
        self.navigationItem.title = "Favorite Foods"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .myRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Rubik-Medium", size: 22)!]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
    }
}

extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favFoodCell", for: indexPath) as! FoodCollectionCell
        let food = foodList[indexPath.row]
        cell.isFavorite = true
        cell.setFav()
        cell.delegate = self
        cell.configure(with: food)
        return cell
    }
}

//MARK: Food CollectionCell Delegate
extension FavoritesVC: FoodCollectionCellDelegate {
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
    
    func addCollectionFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {}
    
    func removeCollectionFoodToCart(yemekAdi: String, completion: @escaping (Bool) -> ()) {}
}
