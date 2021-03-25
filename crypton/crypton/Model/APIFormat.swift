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
    let price: String
    
    let oneDay: Details
    let sevenDays: Details
    let oneMonth: Details
    let oneYear: Details
    
    private enum CodingKeys: String, CodingKey{
        case id, symbol, name, price
        case oneDay = "1d"
        case sevenDays = "7d"
        case oneMonth = "30d"
        case oneYear = "365d"
    }
}

struct Details: Codable {
    let price_change: String
    let price_change_pct: String
}
