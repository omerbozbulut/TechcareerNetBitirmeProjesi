//
//  CartVC.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import UIKit
import SnapKit
import RxSwift
import AlertKit

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
        totalAmountView.addSubviews([totalTitleLabel, totalPriceLabel])
        checkoutView.addSubviews([totalAmountView, checkoutButton])
        minCartView.addSubviews([minCartText])
        containerView.addSubviews([tableView, checkoutView, progressBar, minCartView])
    }
    
    func bindViewModel() {
        _ = viewModel.uniqueCartList.subscribe { foods in
            self.uniqueCartFoods = foods
            self.reload()
            self.didSetTotalPrice()
        }
        
        _ = viewModel.cartList.subscribe { foods in
            self.cartFoods = foods
            self.reload()
            self.didSetTotalPrice()
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
        
        checkoutView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        
        totalAmountView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(140)
            make.height.equalTo(48)
        }
        
        progressBar.snp.makeConstraints { make in
            make.bottom.equalTo(checkoutView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        minCartView.snp.makeConstraints { make in
            make.bottom.equalTo(progressBar.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        minCartText.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(minCartView.snp.top)
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

        let img = UIImage(systemName: "trash.fill") ?? UIImage()
        let button = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(removeAllFood))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
    
    func didSetTotalPrice() {
        totalAmount = 0
        uniqueCartFoods.forEach { food in
            var foodAmount = 0
            if let countStr = food.yemekAdet, let priceStr = food.yemekFiyat, let count = Int(countStr), let price = Int(priceStr)  {
                foodAmount = count * price
            }
            totalAmount += foodAmount
        }
        totalPriceLabel.text = "₺\(totalAmount)"
        updateProgress(currentAmount: Double(totalAmount), minimumAmount: Double(minCartAmount))
    }
    
    func updateProgress(currentAmount: Double, minimumAmount: Double) {
        progressBar.progress = Float(currentAmount / minimumAmount)
        if minimumAmount > currentAmount {
            minCartText.text = "Add items worth ₺\(Int(minimumAmount - currentAmount)) to reach the minimum cart amount."
        } else {
            minCartText.text = "You have reached the minimum cart amount!"
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func checkout() {
        if totalAmount > minCartAmount-1 {
            self.cartFoods.forEach { food in
                self.viewModel.removeFromCart(sepet_yemek: food) { _ in
                }
            }
            
            let img = UIImage(named: "accept")!
            let alertView = AlertAppleMusic17View(title: "Your order has been received.", subtitle: nil, icon: .custom(img))

            alertView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            alertView.titleLabel?.textColor = .black
            alertView.present(on: self.tableView)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                alertView.dismiss()
            })
        }else {
            let img = UIImage(named: "decline")!
            let alertView = AlertAppleMusic17View(title: "You did not reach the sufficient amount.", subtitle: nil, icon: .custom(img))

            alertView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            alertView.titleLabel?.textColor = .black
            alertView.present(on: self.tableView)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                alertView.dismiss()
            })
        }
    }
}

//MARK: Table View
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        uniqueCartFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withClassAndIdentifier: FoodCartCell.self)
        let food = uniqueCartFoods[indexPath.row]
        cell.delegate = self
        cell.configureCell(with: food)
        return cell
    }
}

//MARK: Actions
extension CartVC {
    @objc func removeAllFood() {
        let alertController = UIAlertController(title: "Are you sure you want to delete all foods?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelButton)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.cartFoods.forEach { food in
                self.viewModel.removeFromCart(sepet_yemek: food) { _ in
                }
            }
        }
        alertController.addAction(deleteButton)
        
        self.present(alertController, animated: true)
    }
}

extension CartVC: CartCellDelegate {
    func addFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {
        if let currentFood = uniqueCartFoods.filter({$0.yemekID == yemekID}).first {
            viewModel.addToCart(sepet_yemek: currentFood, completion: { value in
                completion(value)
            })
        }
    }
    
    func removeFoodToCart(yemekID: String, completion: @escaping (Bool) -> ()) {
        if let currentFood = uniqueCartFoods.filter({$0.yemekID == yemekID}).first {
            viewModel.removeFromCart(sepet_yemek: currentFood, completion: { value in
                completion(value)
            })
        }
    }
    
}
