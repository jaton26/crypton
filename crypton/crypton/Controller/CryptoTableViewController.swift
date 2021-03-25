//
//  CryptoTableViewController.swift
//  crypton
//
//  Created by Jason Chong on 3/23/21.
//

import UIKit

class CryptoTableViewController:UIViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cryptoSymbols = [String]()
    var cryptoNames = [String]()
    var cryptoPrices = [String]()
    
    var apiHandler = APIHandler()
    var apiData :[APIFormat]?
    
//    var table = UITableView()
    
    
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self   // Sets search bar to be receiving
        apiHandler.delegate = self
//        table.delegate = self
//        table.dataSource = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        cryptoSymbols = ["DOGE", "BTC"]
//        table.estimatedRowHeight = 100
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CryptoDetails" {
//            let selectedRow = sender as? Int
            
            if let apiData = apiData {
                let destinationVC = segue.destination as! CryptoDetailsController
                destinationVC.apiData = apiData
                
            }
            let destinationVC = segue.destination as! CryptoDetailsController
            destinationVC.name = cryptoSymbols[self.row!]

        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
 
extension CryptoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.row = indexPath.row
        performSegue(withIdentifier: "CryptoDetails", sender: indexPath)
    }
}

extension CryptoTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoSymbols.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "N Items"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoTableCell", for: indexPath) as! CryptoTableViewCell
        
        let row = indexPath.row
        cell.symbolLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell.symbolLabel.text = cryptoSymbols[row]
        
        tableView.tableFooterView = UIView(frame: .zero)    // Get rid of extra lines
        return cell
    }
    
}

extension CryptoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let symbol = searchBar.text
        apiHandler.getData(symbol!)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
}

extension CryptoTableViewController: APIHandlerDelegate {
    func getAPIData(_ data: [APIFormat]) {
        self.apiData = data
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CryptoDetails", sender: data)
        }
    }
    
    
    
}
