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
