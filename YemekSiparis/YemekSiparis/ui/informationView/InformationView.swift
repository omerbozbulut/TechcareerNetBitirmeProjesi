//
//  InformationView.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 24.05.2024.
//

import UIKit

class InformationView: BaseView {

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .myGray
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: .plain("35-45 dk"),
                            textAlignment: .center,
                            numberOfLines: 1,
                            textColor: .darkGray,
                            font:  UIFont(name: "Rubik-Medium", size: 12),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    override func setupViews() {
        self.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }

    func setTitle(title: String) {
        titleLabel.text = title
    }
}
