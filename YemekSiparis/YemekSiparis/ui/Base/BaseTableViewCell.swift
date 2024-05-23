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
