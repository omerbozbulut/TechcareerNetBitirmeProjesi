//
//  FoodCollectionCell.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit
import SnapKit
import Kingfisher

protocol FoodCollectionCellDelegate: AnyObject {
    func addCollectionFoodToCart(yemekID: String, completion: @escaping (Bool) -> ())
    func removeCollectionFoodToCart(yemekAdi: String, completion: @escaping (Bool) -> ())
}

class FoodCollectionCell: BaseCollectionViewCell {
    
    lazy var containerView: UIView = {
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
    
    lazy var addToCartButton: StepperButtonView = {
        let view = StepperButtonView()
        view.delegate = self
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let img = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate) ?? UIImage()

        let button = UIButton(type: .custom,
                              title: .empty,
                              image: img,
                              alignment: .fill,
                              backgroundColor: .clear,
                              titleColor: .red)

        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var foodNameLabel: UILabel = {
        let label = UILabel(text: .plain("Su"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .black,
                            font: UIFont(name: "Rubik-Medium", size: 15),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        return label
    }()
    
    lazy var foodPriceLabel: UILabel = {
        let label = UILabel(text: .plain("₺15"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .black,
                            font:  UIFont(name: "Rubik-Medium", size: 15),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    weak var delegate: FoodCollectionCellDelegate?
    var yemek: Yemekler?
    var cartCount = 0
    
    override func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews([foodImage, foodNameLabel, foodPriceLabel, addToCartButton, likeButton])
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        foodImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(120)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImage.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        
        foodPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartButton.snp.centerY)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(addToCartButton.snp.leading).offset(-8)
            make.height.equalTo(24)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(24)
        }
    }
}

//MARK: Actions
extension FoodCollectionCell {
    @objc func addToFavorite() {
        print("ADDED FAVORİTE")
    }
    
    func configure(with yemek: Yemekler, cartCount: Int) {
        self.cartCount = cartCount
        self.yemek = yemek
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemekResimAdi ?? "ayran.png")") {
            foodImage.kf.setImage(with: url)
        }
        
        foodNameLabel.text = yemek.yemekAdi
        foodPriceLabel.text = "₺\(yemek.yemekFiyat ?? "10")"
        addToCartButton.setSelectedCount()
    }
}

extension FoodCollectionCell: StepperButtonDelegate {
    func setSelectedCount() -> String {
        "\(cartCount)"
    }
    
    func addFoodToCart() {
        if let yemek {
            delegate?.addCollectionFoodToCart(yemekID: yemek.yemekID ?? "0", completion: { value in
                if value {
                    self.addToCartButton.setSelectedCount()
                }
            })
        }
    }
    
    func removeFoodToCart() {
        if let yemek {
            delegate?.removeCollectionFoodToCart(yemekAdi: yemek.yemekAdi ?? "Ayran", completion: { value in
                if value {
                    self.addToCartButton.setSelectedCount()
                }
            })
        }
    }
}
