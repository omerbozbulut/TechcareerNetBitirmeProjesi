//
//  Yemekler.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 20.05.2024.
//

import Foundation

class Yemekler: Codable {
    let yemekID, yemekFiyat: String?
    let yemekAdi, yemekResimAdi: String?

    enum CodingKeys: String, CodingKey {
        case yemekID = "yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
    }
}
