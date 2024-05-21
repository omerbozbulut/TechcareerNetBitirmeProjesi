//
//  FoodRepository.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation
import RxSwift
import Alamofire

class FoodRepository {
    var foodList = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    func getAllFood() {
        let url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let yemekListesi = try JSONDecoder().decode(TumYemekler.self, from: data)
                    if let foods = yemekListesi.yemekler {
                        self.foodList.onNext(foods)
                        print(foods.count)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
