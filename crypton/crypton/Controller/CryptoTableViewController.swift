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
    var cryptoDetailsController = CryptoDetailsController()
    
    var apiData :[APIFormat]?
    var dataList: [APIFormat] = []
    
    var isCellData: Bool?   // Finding which data to pass to VC. Search data or cell data
    var row: Int?   // Finding which row to pass to VC
    
//    var dataList = DataList()     // Linkedlist to store data
    
//    var table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self   // Sets search bar to be receiving
        apiHandler.delegate = self
//        cryptoDetailsController.delegate = self
//        table.delegate = self
//        table.dataSource = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        cryptoSymbols = ["DOGE", "BTC"]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    
    /*
     Preparing to send data from this VC to CryptoDetailController
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CryptoDetails" {
            
            let destinationVC = segue.destination as! CryptoDetailsController
            /*
             Set delegate here because it's this instance where you're calling the second vc that you want the data back.
             It Won't work the normal way because that delegate isn't connected to the vc where we want the data.
             */
            destinationVC.delegate = self
            
            if let isCellData = isCellData {
                if isCellData{
//                    let destinationVC = segue.destination as! CryptoDetailsController
//                    destinationVC.name = cryptoSymbols[self.row!]
//                    destinationVC.isCellData = isCellData
                }
                else{
                    if let apiData = apiData {
//                        let destinationVC = segue.destination as! CryptoDetailsController
//                        destinationVC.apiData = apiData
//                        destinationVC.isCellData = isCellData
                        destinationVC.apiData = apiData
                    }

                }
            }
            
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

/*
Configuring the table view and its cells
 */
extension CryptoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isCellData = true
        
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
//        return cryptoSymbols.count
        return dataList.count
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
//        cell.symbolLabel.text = cryptoSymbols[row]
        cell.symbolLabel.text = dataList[row].id
        
        tableView.tableFooterView = UIView(frame: .zero)    // Get rid of extra lines

        return cell
    }
    
    
    
    
    
    
    
}

/*
Configuring Search Bar
 */
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

/*
 Grabbing information from the APIHandler struct
 */
extension CryptoTableViewController: APIHandlerDelegate {
    func getAPIDataForMultiple(_ data: [APIFormat]) {
        print("Getting API for multiple symbols")
    }
    
    func getAPIDataForSingleUse(_ data: [APIFormat]) {
        self.apiData = data
        self.isCellData = false
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CryptoDetails", sender: data)
        }
    }
}

/*
 Grabbing information from the Crypto Details Controller
 */
extension CryptoTableViewController: CryptoDetailsDelegate{
    func getSavedData(_ data: [APIFormat]) {
        dataList.append(contentsOf: data)
        print(dataList)
        
        
    }
    
    
}
