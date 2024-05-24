//
//  BaseTableViewCell.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 22.05.2024.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        setupViews()
        setupLayout()
    }
    
    open func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    open func setupLayout() {}
}

extension BaseTableViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
