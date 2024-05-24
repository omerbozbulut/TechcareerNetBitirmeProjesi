//
//  FoodCartCell.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 22.05.2024.
//

import UIKit
import SnapKit
import Kingfisher

protocol CartCellDelegate: AnyObject {
    func addFoodToCart(yemekID: String, completion: @escaping (Bool) -> ())
    func removeFoodToCart(yemekID: String, completion: @escaping (Bool) -> ())
}

class FoodCartCell: BaseTableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.addBorder(borderWidth: 2, borderColor: .myGray)
        return view
    }()
    
    lazy var foodImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 15
        return img
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
    
    lazy var stepperButtonView: StepperButtonView = {
        let view = StepperButtonView()
        view.delegate = self
        return view
    }()
    
    weak var delegate: CartCellDelegate?
    var yemek: Sepet_yemekler?
    
    override func setupViews() {
        contentView.addSubview(containerView)
        selectionStyle = .none
        containerView.addSubview(borderView)
        borderView.addSubviews([foodImage, foodNameLabel, foodPriceLabel, stepperButtonView])
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    
        foodImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(100)
        }
        
        stepperButtonView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalTo(foodImage.snp.trailing).offset(16)
            make.trailing.equalTo(stepperButtonView.snp.leading).offset(-8)
        }
        
        foodPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(foodNameLabel.snp.bottom).offset(16)
            make.leading.equalTo(foodImage.snp.trailing).offset(16)
            make.width.equalTo(64)
        }
        
    }
    
    func configureCell(with yemek: Sepet_yemekler) {
        self.yemek = yemek
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemekResimAdi ?? "ayran.png")") {
            foodImage.kf.setImage(with: url)
        }
        
        foodNameLabel.text = yemek.yemekAdi
        foodPriceLabel.text = "₺\(yemek.yemekFiyat ?? "10")"
        stepperButtonView.setSelectedCount()
    }
}


//MARK: Actions
extension FoodCartCell {
    @objc func addToFavorite() {
        print("ADDED FAVORİTE")
    }
}

extension FoodCartCell: StepperButtonDelegate {
    func setSelectedCount() -> String {
        if let yemek {
            return yemek.yemekAdet ?? ""
        } else {
            return "0"
        }
    }
    
    func addFoodToCart() {
        if let yemek {
            print(yemek.yemekID ?? "")
            delegate?.addFoodToCart(yemekID: yemek.yemekID ?? "0", completion: { value in
                if value {
                    self.stepperButtonView.setSelectedCount()
                }
            })
        }
    }
    
    func removeFoodToCart() {
        if let yemek {
            delegate?.removeFoodToCart(yemekID: yemek.yemekID ?? "Ayran", completion: { value in
                self.stepperButtonView.setSelectedCount()
            })
        }
    }
}
