//
//  FoodCollectionCell.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit
import SnapKit
import Kingfisher

class FoodCollectionCell: BaseCollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .myGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var foodBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var foodImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 15
        return img
    }()
    
    lazy var addToCartButton: UIButton = {
        let img = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        img.withTintColor(UIColor.white)

        let button = UIButton(type: .custom,
                              title: .empty,
                              image: img,
                              alignment: .fill,
                              contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                              cornerRadius: 13,
                              backgroundColor: .myRed,
                              titleColor: .white)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()
    
    lazy var foodNameLabel: UILabel = {
        let label = UILabel(text: .plain("Su"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .black,
                            font: .systemFont(ofSize: 13),
                            minimumScaleFactor: 0.6,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        return label
    }()
    
    lazy var foodPriceLabel: UILabel = {
        let label = UILabel(text: .plain("₺15"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .black,
                            font: .systemFont(ofSize: 13),
                            minimumScaleFactor: 0.6,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    var yemek: Yemekler?
    
    override func setupViews() {
        self.addSubview(containerView)
        
        containerView.addSubviews([foodBGView, foodNameLabel, foodPriceLabel, addToCartButton])
        foodBGView.addSubview(foodImage)
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        foodBGView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(120)
        }
        
        foodImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImage.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(16)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
            make.height.width.equalTo(26)
        }
        
        foodPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartButton.snp.centerY)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(addToCartButton.snp.leading).offset(-8)
            make.height.equalTo(16)
        }
    }
}

//MARK: Actions
extension FoodCollectionCell {
    @objc func addToCart() {
        print("ADDED CART")
    }
    
    func configure(with yemek: Yemekler) {
        self.yemek = yemek
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemekResimAdi ?? "ayran.png")") {
            foodImage.kf.setImage(with: url)
        }
        
        foodNameLabel.text = yemek.yemekAdi
        foodPriceLabel.text = "₺\(yemek.yemekFiyat ?? "10")"
    }
}
