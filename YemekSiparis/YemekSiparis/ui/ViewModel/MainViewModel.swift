//
//  MainViewModel.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation
import RxSwift

class MainViewModel {
    var foodRepository = FoodRepository()
    var favoriteReposity = FavoriteFoodRepository()
    
    var favoriteList = BehaviorSubject<[Food]>(value: [Food]())
    var foodList = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var cartList = BehaviorSubject<[Sepet_yemekler]>(value: [Sepet_yemekler]())
    
    init() {
        foodList = foodRepository.foodList
        cartList = foodRepository.cartUniqueFoods
        favoriteList = favoriteReposity.favoriteFoodsList
    }
    
    func getCartFood() {
        foodRepository.getCartFoods()
    }
    
    func getAllFood(completion: @escaping (Bool) -> ()) {
        foodRepository.getAllFood(completion: { value in
            completion(value)
        })
    }
    
    func addToCart(yemek: Yemekler, addCount: Int = 1, completion: @escaping (Bool) -> ()) {
        let sepetYemek = Sepet_yemekler(yemekID: UUID().uuidString, yemekFiyat: yemek.yemekFiyat ?? "", yemekAdi: yemek.yemekAdi ?? "Ayran", yemekResimAdi: yemek.yemekResimAdi ?? "", kullaniciAdi: "Omer_Bozbulut", yemekAdet: "1")
        foodRepository.addToCart(yemek: sepetYemek, addCount: addCount, completion: { value in
            completion(value)
            self.getCartFood()
        })
    }
    
    func removeFromCart(yemek: Sepet_yemekler, completion: @escaping (Bool) -> ()) {
        foodRepository.removeFromCart(yemek: yemek,completion: { value in
            completion(value)
            self.getCartFood()
        })
    }
    
    func save(id: String, name: String, imageName: String, price: String,  completion: @escaping (Bool) -> ()) {
        favoriteReposity.save(id: id, name: name, imageName: imageName, price: price, completion: { value in
            completion(value)
            self.getFavorites()
        })
    }
    
    func delete(food: Food, completion: @escaping (Bool) -> ()) {
        favoriteReposity.delete(food: food, completion: { value in
            completion(value)
            self.getFavorites()
        })
    }
    
    func getFavorites() {
        favoriteReposity.getFavorites()
    }
}
