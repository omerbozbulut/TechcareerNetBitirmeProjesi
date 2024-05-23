//
//  CartViewModel.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 22.05.2024.
//

import Foundation
import RxSwift

class CartViewModel {
    var repository = FoodRepository()
    var cartList = BehaviorSubject<[Sepet_yemekler]>(value: [Sepet_yemekler]())
    
    init() {
         cartList = repository.cartUniqueFoods
    }
    
    func getAllFood() {
        repository.getCartFoods()
        repository.getAllFood()
    }
    
    func addToCart(sepet_yemek: Sepet_yemekler) {
        repository.addToCart(yemek: sepet_yemek)
        getAllFood()
    }
    
    func removeFromCart(sepet_yemek: Sepet_yemekler) {
        repository.removeFromCart(yemek: sepet_yemek)
        getAllFood()
    }
}
