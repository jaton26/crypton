//
//  APIFormat.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import Foundation

struct APIFormat: Codable {
    let id: String
    let symbol: String
    let name: String
    var price: String
    var isPressed: Bool?
    var isPositive: Bool?
    
    var oneDay: Details
    var sevenDays: Details
    var oneMonth: Details
    var oneYear: Details
    
    private enum CodingKeys: String, CodingKey{
        case id, symbol, name, price, isPressed
        case oneDay = "1d"
        case sevenDays = "7d"
        case oneMonth = "30d"
        case oneYear = "365d"
    }
}

struct Details: Codable {
    var price_change: String
    var price_change_pct: String
}
