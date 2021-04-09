//
//  CryptoDetailsController.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import UIKit

protocol CryptoDetailsDelegate {
    func getSavedData(_ data: [APIFormat])
}

class CryptoDetailsController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var apiData: [APIFormat]?
    var delegate: CryptoDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(apiData!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if apiData![0].isPressed == nil {
            apiData![0].isPressed = false
        }
        
        if let isPressed = apiData![0].isPressed {
            if isPressed {
                saveButton.tintColor = UIColor.gray
                apiData![0].isPressed = false
                
            }
            else {
                saveButton.tintColor = UIColor.green
                apiData![0].isPressed = true
            }
            print("hello")
            delegate?.getSavedData(apiData!)
            print("world")
        }
        
        
    }
    
}
