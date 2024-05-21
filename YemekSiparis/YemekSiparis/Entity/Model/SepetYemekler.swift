//
//  SepetYemekler.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation

class Sepet_yemekler: Codable {
    let yemekID: Int?
    let yemekFiyat: Int?
    let yemekAdi, yemekResimAdi, kullaniciAdi: String?
    let yemekAdet: Int?

    enum CodingKeys: String, CodingKey {
        case yemekID = "sepet_yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
        case yemekAdet = "yemek_siparis_adet"
        case kullaniciAdi = "kullanici_adi"
    }
}
