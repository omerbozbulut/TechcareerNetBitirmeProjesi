//
//  UIViewController+Extension.swift
//  MobilliumZoneZero
//
//  Created by Ömer Bozbulut on 9.05.2024.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.10
        transition.type = .push
        transition.subtype = .fromRight
        if self.view.window != nil {
            self.view.window!.layer.add(transition, forKey: kCATransition)
        }
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.10
        transition.type = .push
        transition.subtype = .fromLeft
        if self.view.window != nil {
            self.view.window!.layer.add(transition, forKey: kCATransition)
        }
        
        dismiss(animated: false)
    }
}
