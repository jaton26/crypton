//
//  CryptoTableViewController.swift
//  crypton
//
//  Created by Jason Chong on 3/23/21.
//

import UIKit

class CryptoTableViewController: UITableViewController {

    var cryptoSymbols = [String]()
    var cryptoNames = [String]()
    var cryptoPrices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        cryptoSymbols = ["DOGE", "BTC"]
        tableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoSymbols.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "N Items"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CryptoTableCell", for: indexPath) as! CryptoTableViewCell
        
        let row = indexPath.row
        cell.symbolLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell.symbolLabel.text = cryptoSymbols[row]
        
        tableView.tableFooterView = UIView(frame: .zero)    // Get rid of extra lines
        return cell
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
