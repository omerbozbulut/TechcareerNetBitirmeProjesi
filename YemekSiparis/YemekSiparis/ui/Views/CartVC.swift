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
    
    lazy var checkoutView: UIView = {
        let view = UIView()
        view.backgroundColor = .myGray
        return view
    }()
    
    lazy var totalAmountView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceLabel,totalTitleLabel],
                               axis: .vertical,
                               alignment: .center,
                               distribution: .fillProportionally,
                               spacing: 2)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var minCartView: UIView = {
        let view = UIView()
        view.backgroundColor = .myYellow
        view.layer.cornerRadius = 13
        return view
    }()
    
    lazy var minCartText: UILabel = {
        let label = UILabel(text: .plain("Add items worth ₺30 to reach the minimum cart amount."),
                            textAlignment: .left,
                            numberOfLines: 1,
                            textColor: .myText,
                            font:  UIFont(name: "Rubik-Regular", size: 15),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .myGreen
        return progressView
    }()
    
    lazy var totalTitleLabel: UILabel = {
        let label = UILabel(text: .plain("Total amount"),
                            textAlignment: .center,
                            numberOfLines: 1,
                            textColor: .myText,
                            font:  UIFont(name: "Rubik-Light", size: 13),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    lazy var totalPriceLabel: UILabel = {
        let label = UILabel(text: .plain("₺15"),
                            textAlignment: .center,
                            numberOfLines: 1,
                            textColor: .black,
                            font:  UIFont(name: "Rubik-Medium", size: 25),
                            minimumScaleFactor: 0.8,
                            backgroundColor: .clear,
                            lineSpacing: nil)
        
        return label
    }()
    
    lazy var checkoutButton: UIButton = {
        let image = UIImage(named: "shopping-cart")!.withTintColor(.white)
        let button = UIButton(type: .custom,
                              title: .plain("Checkout"),
                              image: image,
                              alignment: .center,
                              cornerRadius: 15,
                              backgroundColor: .myRed,
                              titleColor: .white)
        
        button.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        return button
    }()
    
    var uniqueCartFoods = [Sepet_yemekler]()
    var cartFoods = [Sepet_yemekler]()
    var viewModel = CartViewModel()
    var minCartAmount = 70
    var totalAmount = 0
    
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
