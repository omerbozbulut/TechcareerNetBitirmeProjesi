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
    
    init() {
        foodList = repository.foodList
    }
    
    func getAllFood() {
        repository.getAllFood()
    }
}
