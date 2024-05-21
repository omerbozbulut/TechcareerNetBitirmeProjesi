//
//  CustomTabBarController.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 21.05.2024.
//

import UIKit
import SnapKit

class CustomTabBarController: UITabBarController {
    
    let middleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .myRed
        
        setupMiddleButton()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let firstVC = MainVC()
        firstVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        
        let secondVC = CartVC()
        secondVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "cart.fill"), tag: 1)
        
        let thirdVC = FavoritesVC()
        thirdVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), tag: 2)
        
        viewControllers = [firstVC, secondVC, thirdVC]
    }
    
    func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 50, height: 50)
        middleButton.backgroundColor = .myRed
        middleButton.layer.cornerRadius = 25
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.minY - 20)
        
        middleButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        middleButton.tintColor = .white
        
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        
        view.addSubview(middleButton)
    }
    
    @objc func middleButtonTapped() {
        selectedIndex = 1 // Ortadaki ViewController'a geçiş yapar.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = tabBar.bounds.height
        let height = view.bounds.height
 
        middleButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.minY + height - tabBarHeight)
    }
}
