//
//  ViewController.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit

class SplashVC: BaseVC {
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .blue
        navigateNextVC()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
    }
    
    func navigateNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showMainApp()
        }
    }
    
    private func showMainApp() {
        let tabBarController = CustomTabBarController()
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}


