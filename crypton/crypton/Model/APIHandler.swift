//
//  File.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import Foundation

protocol APIHandlerDelegate {
    func getAPIDataForSingleUse(_ data: [APIFormat])
    func getAPIDataForMultiple(_ data: [APIFormat])
}

struct APIHandler {
    var delegate: APIHandlerDelegate?
    
    func getData(_ symbol: String){
        var jsonData: [APIFormat]?
        
        let url = URL(string: "https://api.nomics.com/v1/currencies/ticker?key=833733efce692d28402d88fe4052555a&ids=\(symbol)&convert=USD")!
        let task = URLSession.shared.dataTask(with: url) {data, res, err in
            
            if let safeData = data {
                jsonData = getJSON(safeData)
                if var jsonData = jsonData {
                    jsonData = convertToFloat(&jsonData)
                    if jsonData.count == 1 {
                        delegate?.getAPIDataForSingleUse(jsonData)
                    }
                    else{
                        delegate?.getAPIDataForMultiple(jsonData)
                    }
                }
            }
            
            if let error = err {
                print(error)
            }
            
            
        } .resume()
    }
    
    func getJSON(_ data: Data) -> [APIFormat] {
        
        let decoder = try! JSONDecoder().decode([APIFormat].self, from: data)
        return decoder
        
    }
    
    func convertToFloat(_ jsonData: inout [APIFormat]) -> [APIFormat] {
        var temp: Float = 0
        for (i,item) in jsonData.enumerated() {
            temp = Float(item.price)!
            jsonData[i].price = String(format: "%.2f", temp)
            
            temp = Float(item.oneDay.price_change)!
            jsonData[i].oneDay.price_change = String(format: "%.2f", temp)
            
            temp = Float(item.sevenDays.price_change)!
            jsonData[i].sevenDays.price_change = String(format: "%.2f", temp)
            
            temp = Float(item.oneMonth.price_change)!
            jsonData[i].oneMonth.price_change = String(format: "%.2f", temp)
            
            temp = Float(item.oneYear.price_change)!
            jsonData[i].oneYear.price_change = String(format: "%.2f", temp)
        }
        return jsonData
    }
    
    
}
