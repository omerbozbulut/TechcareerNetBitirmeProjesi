//
//  MainViewModel.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation
import RxSwift

class MainViewModel {
    var repository = FoodRepository()
    var foodList = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var cartList = BehaviorSubject<[Sepet_yemekler]>(value: [Sepet_yemekler]())
    
    init() {
        foodList = repository.foodList
        cartList = repository.cartUniqueFoods
    }
    
    func getAllFood() {
        repository.getAllFood()
        repository.getCartFoods()
    }
    
    func addToCart(yemek: Yemekler) {
        let sepetYemek = Sepet_yemekler(yemekID: yemek.yemekID ?? "", yemekFiyat: yemek.yemekFiyat ?? "", yemekAdi: yemek.yemekAdi ?? "", yemekResimAdi: yemek.yemekResimAdi ?? "", kullaniciAdi: "OmerBozbulut", yemekAdet: "1")
        repository.addToCart(yemek: sepetYemek)
        getAllFood()
    }
    
    func removeFromCart(yemek: Sepet_yemekler) {
        repository.removeFromCart(yemek: yemek)
        getAllFood()
    }
}
