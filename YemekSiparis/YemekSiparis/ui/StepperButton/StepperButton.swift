//
//  StepperButton.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit

protocol StepperButtonDelegate: AnyObject {
    func addFoodToCart()
    func removeFoodToCart()
    func setSelectedCount() -> String
}

class StepperButtonView: BaseView {
    
    lazy var containerView: UIView = {
        return UIView()
    }()
    
    lazy var buttonBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.addBorder(borderWidth: 1, borderColor: .myRed)
        return view
    }()
    
    lazy var increaseButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("+"),
                              image: nil,
                              alignment: .center,
                              contentEdgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                              backgroundColor: .clear,
                              titleColor: .black)

        button.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        return button
    }()
    
    lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("-"),
                              image: nil,
                              alignment: .center,
                              contentEdgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                              backgroundColor: .clear,
                              titleColor: .black)

        button.addTarget(self, action: #selector(decreaseCount), for: .touchUpInside)
        return button
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("+"),
                              image: nil,
                              alignment: .center,
                              cornerRadius: 20,
                              //contentEdgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                              backgroundColor: .myRed,
                              titleColor: .white)

        button.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        return button
    }()
    
    lazy var countBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .myRed
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel(text: .plain("2"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .white,
                            font: UIFont(name: "Rubik-Medium", size: 12),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        return label
    }()
    
    weak var delegate: StepperButtonDelegate?
    var selectedCount = 0

    override func setupViews() {
        self.addSubview(containerView)
        containerView.addSubviews([buttonBorderView, addToCartButton])
        countBGView.addSubview(countLabel)
        buttonBorderView.addSubviews([countBGView, increaseButton, decreaseButton])
        
        cartButtonConfigure()
        setSelectedCount()
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        buttonBorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        countBGView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        increaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.leading.equalTo(countBGView.snp.trailing)
            make.trailing.equalToSuperview()
        }
        
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.leading.equalToSuperview()
            make.trailing.equalTo(countBGView.snp.leading)
        }
    }
    
    func setSelectedCount() {
        self.selectedCount = Int(delegate?.setSelectedCount() ?? "0") ?? 0
        cartButtonConfigure()
    }
    
    func cartButtonConfigure() {
        countLabel.text = "\(selectedCount)"
        if selectedCount < 1 {
            addToCartButton.isHidden = false
            buttonBorderView.isHidden = true
            countBGView.isHidden = true
            countLabel.isHidden = true
            decreaseButton.isHidden = true
            increaseButton.isHidden = true
        } else {
            addToCartButton.isHidden = true
            buttonBorderView.isHidden = false
            countBGView.isHidden = false
            countLabel.isHidden = false
            decreaseButton.isHidden = false
            increaseButton.isHidden = false
        }
    }
}

//MARK: Actions
extension StepperButtonView {
    @objc func increaseCount() {
        delegate?.addFoodToCart()
        setSelectedCount()
    }
    
    @objc func decreaseCount() {
        delegate?.removeFoodToCart()
        setSelectedCount()
    }
    
}
