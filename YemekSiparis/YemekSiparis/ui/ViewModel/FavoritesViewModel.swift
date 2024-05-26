//
//  FavoritesViewModel.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 25.05.2024.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    var favRepo = FavoriteFoodRepository()
    var favoriteList = BehaviorSubject<[Food]>(value: [Food]())
    
    init() {
        favoriteList = favRepo.favoriteFoodsList
    }
    
    func save(id: String, name: String, imageName: String, price: String, completion: @escaping (Bool) -> ()) {
        favRepo.save(id: id, name: name, imageName: imageName, price: price, completion: { value in
            completion(value)
            self.getFavorites()
        })
    }
    
    func delete(food: Food, completion: @escaping (Bool) -> ()) {
        favRepo.delete(food: food, completion: { value in
            completion(value)
            self.getFavorites()
        })
    }
    
    func getFavorites() {
        favRepo.getFavorites()
    }
}
