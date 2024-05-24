//
//  DetailStepperButton.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 23.05.2024.
//

import UIKit

protocol DetailStepperButtonDelegate: AnyObject {
    func updatePrice()
}

class DetailStepperButton: BaseView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .myRed
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var increaseButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("+"),
                              image: nil,
                              alignment: .center,
                              cornerRadius: 20,
                              backgroundColor: .white,
                              titleColor: .myRed,
                              cornerStyle: .capsule)
        
        button.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        return button
    }()
    
    lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .plain("-"),
                              image: nil,
                              alignment: .center,
                              cornerRadius: 20,
                              backgroundColor: .white,
                              titleColor: .myRed,
                              cornerStyle: .capsule)
        
        button.addTarget(self, action: #selector(decreaseCount), for: .touchUpInside)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel(text: .plain("2"),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .white,
                            font: UIFont(name: "Rubik-Medium", size: 20),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        return label
    }()
    
    weak var delegate: DetailStepperButtonDelegate?
    var selectedCount = 1
    
    override func setupViews() {
        self.addSubview(containerView)
        containerView.addSubviews([increaseButton, countLabel, decreaseButton])
        
        setSelectedCount()
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        increaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(38)
            make.trailing.equalToSuperview().inset(1)
        }
        
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(38)
            make.leading.equalToSuperview().inset(1)
        }
    }
    
    func setSelectedCount() {
        countLabel.text = "\(selectedCount)"
    }
}

//MARK: Actions
extension DetailStepperButton {
    @objc func increaseCount() {
        if selectedCount < 99 {
            self.selectedCount+=1
            delegate?.updatePrice()
            setSelectedCount()
        }
    }
    
    @objc func decreaseCount() {
        if selectedCount > 1 {
            self.selectedCount-=1
            delegate?.updatePrice()
            setSelectedCount()
        }
    }
}
