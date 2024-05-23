//
//  SepetYemekler.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation

class Sepet_yemekler: Codable {
    let yemekID: String?
    let yemekFiyat: String?
    let yemekAdi, yemekResimAdi, kullaniciAdi: String?
    var yemekAdet: String?

    enum CodingKeys: String, CodingKey {
        case yemekID = "sepet_yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
        case yemekAdet = "yemek_siparis_adet"
        case kullaniciAdi = "kullanici_adi"
    }
    
    init(yemekID: String, yemekFiyat: String, yemekAdi: String, yemekResimAdi: String, kullaniciAdi: String, yemekAdet: String) {
        self.yemekID = yemekID
        self.yemekFiyat = yemekFiyat
        self.yemekAdi = yemekAdi
        self.yemekResimAdi = yemekResimAdi
        self.kullaniciAdi = kullaniciAdi
        self.yemekAdet = yemekAdet
    }
}
