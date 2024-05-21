//
//  UIImageView+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 10.05.2024.
//

import UIKit

extension UIImageView {
    convenience init(
        image: UIImage?,
        contentMode: UIView.ContentMode,
        backgroundColor: UIColor? = .clear) {
        
        self.init(image: image)
        
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
    }
}
