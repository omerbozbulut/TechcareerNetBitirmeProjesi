//
//  DetailVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit

protocol DetailDelegate: AnyObject {
    func addFoodCart(yemekID: String, count: Int, completion: @escaping (Bool) -> ())
}

class DetailVC: BaseVC {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var navigationView: CustomNavigationView = {
        let view = CustomNavigationView("Food Detail")
        view.delegate = self
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
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
                            textAlignment: .center,
                            numberOfLines: 1,
                            textColor: .black,
                            font: UIFont(name: "Rubik-Medium", size: 28),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        return label
    }()
    
    lazy var totalPriceLabel: UILabel = {
        let label = UILabel(text: .plain("₺15"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .myRed,
                            font:  UIFont(name: "Rubik-Medium", size: 35),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    lazy var foodPriceLabel: UILabel = {
        let label = UILabel(text: .plain("₺15"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .myRed,
                            font:  UIFont(name: "Rubik-Medium", size: 27),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
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
    
    lazy var stepperButtonView: DetailStepperButton = {
        let button = DetailStepperButton()
        button.delegate = self
        return button
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("Add to Cart"),
                              image: nil,
                              alignment: .center,
                              cornerRadius: 12,
                              //contentEdgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                              backgroundColor: .myRed,
                              titleColor: .white)

        button.addTarget(self, action: #selector(addFoodToCart), for: .touchUpInside)
        return button
    }()
    
    lazy var discountInformation: InformationView = {
        let view = InformationView()
        view.setTitle(title: "%10 Discount")
        return view
    }()
    
    lazy var timeInformation: InformationView = {
        let view = InformationView()
        view.setTitle(title: "35-45 min")
        return view
    }()
    
    lazy var freeDeliveryInformation: InformationView = {
        let view = InformationView()
        view.setTitle(title: "Free Delivery")
        return view
    }()
    
    lazy var informationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [discountInformation, timeInformation, freeDeliveryInformation],
                                axis: .horizontal,
                                alignment: .fill,
                                distribution: .fillEqually,
                                spacing: 5)
        return stack
    }()
    
    weak var delegate: DetailDelegate?
    var yemek: Yemekler?
    var cartCount = 0

    override func setupViews() {
        view.addSubview(containerView)
        
        containerView.addSubviews([navigationView, lineView,foodImage, foodNameLabel, foodPriceLabel, informationStack, stepperButtonView, likeButton, totalPriceLabel, addToCartButton])
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(100)
        }
    
        foodImage.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(260)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(foodImage.snp.bottom)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        foodPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(foodNameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(32)
        }
        
        informationStack.snp.makeConstraints { make in
            make.top.equalTo(foodPriceLabel.snp.bottom).offset(32)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        stepperButtonView.snp.makeConstraints { make in
            make.bottom.equalTo(totalPriceLabel.snp.top).offset(-64)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-64)
            make.leading.equalToSuperview().offset(32)
            make.height.equalTo(32)
            make.width.equalTo(120)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.centerY.equalTo(totalPriceLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
            make.leading.equalTo(totalPriceLabel.snp.trailing).offset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }
    }
    
    func configureDetail(with yemek: Yemekler, count: Int) {
        self.yemek = yemek
        self.cartCount = count
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemekResimAdi ?? "ayran.png")") {
            foodImage.kf.setImage(with: url)
        }
        
        foodNameLabel.text = yemek.yemekAdi
        foodPriceLabel.text = "₺\(yemek.yemekFiyat ?? "10")"
        stepperButtonView.setSelectedCount()
        
        let totalPrice = (Int(yemek.yemekFiyat!) ?? 1) * stepperButtonView.selectedCount
        totalPriceLabel.text = "₺\(totalPrice)"
    }
    
    @objc func addToFavorite() {
        
    }
}

extension DetailVC {
    @objc func addFoodToCart() {
        if let yemek {
            print(yemek.yemekID ?? "")
            delegate?.addFoodCart(yemekID: yemek.yemekID ?? "0", count: stepperButtonView.selectedCount, completion: { value in
                if value {
                    // show alert
                }
            })
        }
    }
}

extension DetailVC: NavigationViewDelegate {
    func backButtonTapped() {
        dismissDetail()
    }
    
    func rightButtonTapped() {
        
    }
}

extension DetailVC: DetailStepperButtonDelegate {
    func updatePrice() {
        if let yemek {
            let totalPrice = (Int(yemek.yemekFiyat!) ?? 1) * stepperButtonView.selectedCount
            totalPriceLabel.text = "₺\(totalPrice)"
        }
    }
}
