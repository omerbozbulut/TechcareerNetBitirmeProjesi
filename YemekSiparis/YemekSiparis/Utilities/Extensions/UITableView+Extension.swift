//
//  UITableView+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import UIKit

extension UITableView {
    
    func registerNib<T>(witClassAndIdentifier:T.Type) {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
    func registerClass(cell: UITableViewCell.Type) {
        register(cell.classForCoder(), forCellReuseIdentifier: cell.className)
    }
    
    public func dequeueCell<T>(withClassAndIdentifier classAndIdentifier: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    public func dequeueCell<T>(withClassAndIdentifier classAndIdentifier: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
    
    
}
