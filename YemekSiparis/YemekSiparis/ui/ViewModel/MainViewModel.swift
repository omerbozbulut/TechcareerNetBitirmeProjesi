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
    
    func getCartFood() {
        repository.getCartFoods()
    }
    
    func getAllFood(completion: @escaping (Bool) -> ()) {
        repository.getAllFood(completion: { value in
            completion(value)
        })
    }
    
    func addToCart(yemek: Yemekler, addCount: Int = 1, completion: @escaping (Bool) -> ()) {
        let sepetYemek = Sepet_yemekler(yemekID: UUID().uuidString, yemekFiyat: yemek.yemekFiyat ?? "", yemekAdi: yemek.yemekAdi ?? "Ayran", yemekResimAdi: yemek.yemekResimAdi ?? "", kullaniciAdi: "Omer_Bozbulut", yemekAdet: "1")
        repository.addToCart(yemek: sepetYemek, addCount: addCount, completion: { value in
            completion(value)
        })
        getCartFood()
    }
    
    func removeFromCart(yemek: Sepet_yemekler, completion: @escaping (Bool) -> ()) {
        repository.removeFromCart(yemek: yemek,completion: { value in
            completion(value)
        })
        getCartFood()
    }
    
    func findFood() {
        _ = foodList.subscribe({ foods in
            
        })
    }
}
