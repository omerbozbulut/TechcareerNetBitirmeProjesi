//
//  OCollectionViewCell.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        backgroundColor = .white
    }
    
    func setupLayout() {}
    
}

// MARK: - Reuse
extension BaseCollectionViewCell: Reuse {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension BaseCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol Reuse:AnyObject {
    static var reuseIdentifier: String { get }
    
}
