//
//  UILabel+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 10.05.2024.
//

import UIKit

extension UILabel {
    convenience init(
        text: TextType,
        textAlignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1,
        textColor: UIColor? = .black,
        font: UIFont? = nil,
        minimumScaleFactor: CGFloat = 1.0,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        backgroundColor: UIColor? = .clear,
        lineSpacing: CGFloat? = nil) {
            
            self.init()
            
            self.textAlignment = textAlignment
            self.numberOfLines = numberOfLines
            self.textColor = textColor
            
            if let aFont = font {
                self.font = aFont
            }
            
            if minimumScaleFactor < 1 {
                self.adjustsFontSizeToFitWidth = true
                self.minimumScaleFactor = minimumScaleFactor
            }
            
            self.lineBreakMode = lineBreakMode
            self.backgroundColor = backgroundColor
            
            switch text {
            case .plain(let string):
                self.text = string
            case .attributed(let attributedText):
                self.attributedText = attributedText
            case .empty:
                self.attributedText = nil
                self.text = nil
            }
            
            if let lineSpacing = lineSpacing {
                self.setLineSpacing(lineSpacing: lineSpacing, lineHeightMultiple: 1)
            }
        }
    
    public func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
