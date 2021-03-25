//
//  CryptoDetailsController.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import UIKit

class CryptoDetailsController: UIViewController {

    var name: String = ""
    var apiData: [APIFormat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(name)
        if let apiData = apiData {
            print(apiData)
        }
        // Do any additional setup after loading the view.
    }
    

}
