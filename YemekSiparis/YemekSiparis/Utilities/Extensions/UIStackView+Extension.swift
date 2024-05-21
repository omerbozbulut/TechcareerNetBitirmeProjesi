//
//  UIStackView.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0.0) {
        
        self.init(arrangedSubviews: arrangedSubviews)
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
    
    func addArranged(subviews:[UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
