//
//  Model.swift
//  CryptoTracker
//
//  Created by Abhishek Kumar on 05/06/21.
//

import Foundation

struct Crypto: Codable {
    let assetID: String
    let name: String?
    let priceUsd: Double?
    let idIcon: String?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case name
        case priceUsd = "price_usd"
        case idIcon = "id_icon"
    }
}


struct Icon: Codable {
    let assetID: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case url
    }
}
