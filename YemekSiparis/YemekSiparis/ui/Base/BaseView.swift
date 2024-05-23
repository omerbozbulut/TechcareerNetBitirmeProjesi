//
//  BaseView.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit

class BaseView: UIView {
    
    init(backgroundColor: UIColor?, cornerRadius: CGFloat? = nil, isHidden: Bool = false) {
        self.init()
        
        self.backgroundColor = backgroundColor
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        
        self.isHidden = isHidden
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        setupLayout()
    }
    
    /// Setup view and its subviews here.
    open func setupViews() {
        backgroundColor = .white
    }
    
    /// Setup view and its subviews autolayout here.
    open func setupLayout() {}
}
