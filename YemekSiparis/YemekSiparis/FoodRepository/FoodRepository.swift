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
    var cartList = BehaviorSubject<[Sepet_yemekler]>(value: [Sepet_yemekler]())
    var cartUniqueFoods = BehaviorSubject<[Sepet_yemekler]>(value: [Sepet_yemekler]())
    
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
    
    func getCartFoods() {
        let url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php"
        let params: Parameters = ["kullanici_adi": "OmerBozbulut"]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let yemekListesi = try JSONDecoder().decode(SepetTumyemekler.self, from: data)
                    if let foods = yemekListesi.sepet_yemekler {
                        self.cartList.onNext(foods)
                        self.setUniqueFoods()
                    }
                } catch {
                    print("CART ERROR")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addToCart(yemek: Sepet_yemekler) {
        let url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php"
    
        let params: Parameters = ["yemek_adi": yemek.yemekAdi ?? "Ayran", "yemek_resim_adi": yemek.yemekResimAdi ?? "ayran.png", "yemek_fiyat": yemek.yemekFiyat ?? "10", "yemek_siparis_adet": yemek.yemekAdet ?? "1", "kullanici_adi": "OmerBozbulut"]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print(cevap.message!)
                    print(cevap.success!)
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func removeFromCart(yemek: Sepet_yemekler) {
        let url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"
        let params: Parameters = ["sepet_yemek_id": yemek.yemekID ?? "0", "kullanici_adi": "OmerBozbulut"]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print(cevap.message!)
                    print(cevap.success!)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setUniqueFoods() {
        var yemekDictionary = [String: Sepet_yemekler]()
        
        _ = cartList.subscribe { cartFoods in
            for yemek in cartFoods {
                if let ad = yemek.yemekAdi, let adet = yemek.yemekAdet, let adetInt = Int(adet) {
                    if let mevcutYemek = yemekDictionary[ad] {
                        if let mevcutAdet = mevcutYemek.yemekAdet, let mevcutAdetInt = Int(mevcutAdet) {
                            mevcutYemek.yemekAdet = String(mevcutAdetInt + adetInt)
                        }
                    } else {
                        yemekDictionary[ad] = yemek
                    }
                }
            }
            self.cartUniqueFoods.onNext(Array(yemekDictionary.values))
        }
    }
}
