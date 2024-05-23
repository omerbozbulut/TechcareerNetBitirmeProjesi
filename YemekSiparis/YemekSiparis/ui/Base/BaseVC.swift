//
//  BaseVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
        observeDataSource()
        observeViewModel()
    }
    
    func push(to: UIViewController, completionHandler: (() -> Void)? = nil, animated: Bool = true) {
        navigationController?.pushViewController(to, animated: animated)
        completionHandler?()
    }
    
    func present(to: UIViewController) {
        to.modalPresentationStyle = .fullScreen
        presentDetail(to)
    }
}

// MARK: - Setup LifeCycle
extension BaseVC {
    @objc open func setupViews() {}

    @objc open func setupLayout() {}

    @objc open func observeViewModel() {}

    @objc open func observeDataSource() {}
}

