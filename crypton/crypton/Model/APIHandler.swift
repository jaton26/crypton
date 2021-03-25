//
//  File.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import Foundation

protocol APIHandlerDelegate {
    func getAPIData(_ data: [APIFormat])
}

struct APIHandler {
    var delegate: APIHandlerDelegate?
    
    func getData(_ symbol: String){
        var jsonData: [APIFormat]?
        
        let url = URL(string: "https://api.nomics.com/v1/currencies/ticker?key=833733efce692d28402d88fe4052555a&ids=\(symbol)&convert=USD")!
        let task = URLSession.shared.dataTask(with: url) {data, res, err in
            
            if let safeData = data {
                jsonData = getJSON(safeData)
                if let jsonData = jsonData {
                    delegate?.getAPIData(jsonData)
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
}
