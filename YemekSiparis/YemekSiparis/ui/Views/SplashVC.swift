//
//  ViewController.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit
import Lottie

class SplashVC: BaseVC {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .myRed
        return view
    }()
    
    lazy var animationView: LottieAnimationView = {
        var animation = LottieAnimationView(name: "loadingAnimation")
        animation.contentMode = .scaleAspectFit
        animation.animationSpeed = 1.0
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(containerView)
        containerView.addSubview(animationView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.centerY.equalToSuperview()
        }
        
        navigateNextVC()
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


