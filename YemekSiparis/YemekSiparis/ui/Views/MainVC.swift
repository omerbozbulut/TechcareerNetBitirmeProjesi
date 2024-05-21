//
//  MainVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit

class MainVC: BaseVC {
    
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
        layout.itemSize = CGSize(width: cellWidth, height: height/2)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "foodCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var foodList = [Yemekler]()
    var viewModel = MainViewModel()
    
    override func setupViews() {
        super.setupViews()
        
        bindViewModel()
        viewModel.getAllFood()
        
        view.addSubview(containerView)
        containerView.addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(64)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func bindViewModel() {
        _ = viewModel.foodList.subscribe { foods in
            self.foodList = foods
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
        cell.configure(with: food)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let food = foodList[indexPath.row]
       
        //navigationController?.pushViewController(generateVC, animated: true)
    }
}


extension MainVC {
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
