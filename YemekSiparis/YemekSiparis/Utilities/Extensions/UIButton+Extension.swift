//
//  UIButton+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import UIKit

extension UIButton {
    convenience init(
        type: ButtonType,
        title: TextType? = nil,
        image: UIImage? = nil,
        titleFont: UIFont? = nil,
        alignment: ContentHorizontalAlignment = .center,
        contentEdgeInsets: UIEdgeInsets = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0),
        cornerRadius: CGFloat? = 0.0,
        isEnabled: Bool = true,
        backgroundColor: UIColor? = .white,
        titleColor: UIColor? = .black) {
            
            self.init(type: type)
            
            if let aTitle = title {
                switch aTitle {
                case .plain(let string):
                    setTitle(string, for: .normal)
                case .attributed(let string):
                    setAttributedTitle(string, for: .normal)
                case .empty:
                    setAttributedTitle(nil, for: .normal)
                    setTitle(nil, for: .normal)
                }
            }
            
            setImage(image, for: .normal)
            
            if let font = titleFont {
                titleLabel?.font = font
            }
            if let cornerRadius = cornerRadius {
                self.layer.cornerRadius = cornerRadius
            }
            
            var conf = UIButton.Configuration.filled()
            conf.contentInsets = NSDirectionalEdgeInsets(top: contentEdgeInsets.top, leading: contentEdgeInsets.left, bottom: contentEdgeInsets.bottom, trailing: contentEdgeInsets.right)
            conf.baseBackgroundColor = backgroundColor
            conf.imagePadding = 10
            conf.baseForegroundColor = titleColor
            self.configuration = conf
            
            self.contentHorizontalAlignment = alignment
            self.isEnabled = isEnabled
            
            self.backgroundColor = backgroundColor
            self.setTitleColor(titleColor, for: .normal)
            
        }
}
