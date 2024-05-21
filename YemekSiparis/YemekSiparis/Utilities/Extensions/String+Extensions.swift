//
//  String+Extensions.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import Foundation

extension String {
    
    public func localized(comment:String = " ") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }
    
    public class var className: String {
        return String(describing: self)
    }
}
