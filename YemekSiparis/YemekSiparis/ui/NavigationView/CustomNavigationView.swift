//
//  CustomNavigationView.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 23.05.2024.
//

import UIKit

protocol NavigationViewDelegate: AnyObject {
    func backButtonTapped()
    func rightButtonTapped()
}

class CustomNavigationView: BaseView {
    
    lazy var containerView: BaseView = {
        return BaseView(backgroundColor: .myRed)
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom,
                              title: .none,
                              image: UIImage(systemName: "arrow.backward"),
                              isEnabled: true,
                              backgroundColor: .clear,
                              titleColor: .white)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: .plain(""), textAlignment: .center, numberOfLines: 1, textColor: .white, backgroundColor: .clear)
        label.font = UIFont(name: "Rubik-Medium", size: 22)
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom,
                              image: UIImage(named: "closeIcon"),
                              isEnabled: true,
                              backgroundColor: .clear)
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: BaseView = {
        return BaseView(backgroundColor: .myLine)
    }()
    
    weak var delegate: NavigationViewDelegate?
    
    init(_ title: String, backImage: UIImage? = UIImage(systemName: "arrow.backward"), isAddLineView: Bool = true, backButtonHidden: Bool = false, rightButtonHidden: Bool = true) {
        super.init(frame: .zero)
        titleLabel.text = title
        backButton.setImage(backImage, for: .normal)
        lineView.isHidden = !isAddLineView
        if backButtonHidden {
            backButton.isHidden = true
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(70)
                make.leading.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(18)
            }
        }
        
        rightButton.isHidden = rightButtonHidden
    }
    
    func setBackButtonHidden(backButtonHidden: Bool) {
        if backButtonHidden {
            backButton.isHidden = true
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(70)
                make.leading.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(18)
            }
        } else {
            backButton.isHidden = false
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(backButton.snp.trailing).offset(16)
                make.centerY.equalTo(backButton).offset(2)
                make.trailing.equalToSuperview().inset(25)
            }
        }
    }
    
    func setRightButtonHidden(rightButtonHidden: Bool) {
        rightButton.isHidden = rightButtonHidden
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        self.addSubview(containerView)
        containerView.addSubviews([backButton, rightButton, titleLabel, lineView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(64)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(16)
            make.centerY.equalTo(backButton).offset(2)
            make.trailing.equalTo(rightButton.snp.leading).offset(4)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension CustomNavigationView {
    @objc func didTapBackButton(){
        delegate?.backButtonTapped()
    }
    
    @objc func didTapRightButton(){
        delegate?.rightButtonTapped()
    }
}
