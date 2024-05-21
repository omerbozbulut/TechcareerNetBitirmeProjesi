//
//  UITextField+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import UIKit

extension UITextField {

    convenience init(
        placeholder: TextType?,
        text: TextType? = nil,
        textAlignment: NSTextAlignment = .natural,
        textType: TextFieldType = .generic,
        textColor: UIColor? = .black,
        font: UIFont? = nil,
        borderStyle: BorderStyle = .none,
        backgroundColor: UIColor? = .white,
        tintColor: UIColor? = nil) {
            
            self.init()
            self.layer.masksToBounds = true
            
            if let aPlaceholder = placeholder {
                switch aPlaceholder {
                case .plain(let string):
                    attributedPlaceholder = NSAttributedString(
                        string: string,
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 127.0 / 255.0, alpha: 1.0)]
                    )
                    self.placeholder = string
                case .attributed(let string):
                    self.attributedPlaceholder = string
                case .empty:
                    self.attributedPlaceholder = nil
                    self.placeholder = nil
                }
            }
            
            if let aText = text {
                switch aText {
                case .plain(let string):
                    self.text = string
                case .attributed(let string):
                    self.attributedText = string
                case .empty:
                    self.attributedText = nil
                    self.text = nil
                }
            }
            
            self.textAlignment = textAlignment
            self.setTextType(textType)
            self.textColor = textColor
            
            if let aFont = font {
                self.font = aFont
            }
            
            self.borderStyle = borderStyle
            
            switch borderStyle {
            case .none:
                break
            case .line:
                break
            case .bezel:
                break
            case .roundedRect:
                //addBorder(borderWidth: 1, borderColor: .gray)
                layer.cornerRadius = 8
                break
            default:
                break
            }
            
            self.backgroundColor = backgroundColor
            if let color = tintColor {
                self.tintColor = color
            }
        }
    
    func setTextType(_ type: TextFieldType) {
        isSecureTextEntry = (type == .password)
        
        switch type {
        case .emailAddress:
            keyboardType = .emailAddress
            autocorrectionType = .no
            autocapitalizationType = .none
            
            if #available(iOS 10.0, *) {
                textContentType = .emailAddress
            }
            
        case .url:
            keyboardType = .URL
            autocorrectionType = .no
            autocapitalizationType = .none
            
            if #available(iOS 10.0, *) {
                textContentType = .URL
            }
            
        case .phoneNumber:
            if #available(iOS 10.0, *) {
                keyboardType = .asciiCapableNumberPad
            } else {
                keyboardType = .numberPad
            }
            
            if #available(iOS 10.0, *) {
                textContentType = .telephoneNumber
            }
            
        case .decimal:
            keyboardType = .decimalPad
            
        case .password:
            keyboardType = .asciiCapable
            autocorrectionType = .no
            autocapitalizationType = .none
            
            if #available(iOS 11.0, *) {
                textContentType = .password
            }
            
        case .generic:
            keyboardType = .asciiCapable
            autocorrectionType = .default
            autocapitalizationType = .sentences
        }
    }
}
