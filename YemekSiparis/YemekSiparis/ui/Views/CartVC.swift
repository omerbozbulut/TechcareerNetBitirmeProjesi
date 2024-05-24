//
//  CartVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit
import RxSwift

class CartVC: BaseVC {
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.registerClass(cell: FoodCartCell.self)
        return tableView
    }()
    
    var cartFoods = [Sepet_yemekler]()
    var viewModel = CartViewModel()
    
    override func setupViews() {
        super.setupViews()
        
        setNavbar()
        viewModel.getAllFood()
        bindViewModel()
        
        view.addSubview(containerView)
        containerView.addSubviews([tableView])
    }
    
    func bindViewModel() {
        _ = viewModel.cartList.subscribe { foods in
            self.cartFoods = foods
            self.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllFood()
    }
    
    override func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setNavbar() {
        self.navigationItem.title = "Cart"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .myRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Rubik-Medium", size: 22)!]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        
        let img = UIImage(named: "trash.fill") ?? UIImage()
        let button = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(removeAllFood))
        navigationItem.rightBarButtonItem = button
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: Table View
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withClassAndIdentifier: FoodCartCell.self)
        let food = cartFoods[indexPath.row]
        cell.delegate = self
        cell.configureCell(with: food)
        return cell
    }
}

//MARK: Actions
extension CartVC {
    @objc func removeAllFood() {
        //MARK: Remove all
    }
}

extension CartVC: CartCellDelegate {
    func addFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {
        if let currentFood = cartFoods.filter({$0.yemekID == yemekID}).first {
            viewModel.addToCart(sepet_yemek: currentFood, completion: { value in
                completion(value)
            })
        }
    }
    
    func removeFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {
        if let currentFood = cartFoods.filter({$0.yemekID == yemekID}).first {
            viewModel.removeFromCart(sepet_yemek: currentFood, completion: { value in
                completion(value)
            })
        }
    }
    
}
