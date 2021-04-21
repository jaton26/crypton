//
//  CryptoTableViewController.swift
//  crypton
//
//  Created by Jason Chong on 3/23/21.
//

import UIKit

class CryptoTableViewController:UITableViewController{
    @IBOutlet weak var searchBar: UISearchBar!

    var apiHandler = APIHandler()
    
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

//        table.delegate = self
//        table.dataSource = self
        
        apiHandler.getData("BTC,ETH,LTC")
        
        // Setting the attributes of the navigation bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)]
        navigationController?.navigationBar.barStyle = UIBarStyle.black     // Changes the the bar with battery, time, carrier, etc to light
        
        searchBar.searchTextField.leftView?.tintColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        searchBar.searchTextField.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)

        navigationItem.hidesSearchBarWhenScrolling = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    /*
     Preparing to send data from this VC to CryptoDetailController
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a temp list
        if segue.identifier == "CryptoDetails" {
            
            let destinationVC = segue.destination as! CryptoDetailsController
            /*
             Set delegate here because it's this instance where you're calling the second vc that you want the data back.
             It Won't work the normal way because that delegate isn't connected to the vc where we want the data.
             */
            destinationVC.delegate = self
            
            if let isCellData = isCellData {
                if isCellData{
                    destinationVC.apiData = dataList[self.row!]
                    destinationVC.valueList = [dataList[self.row!].oneDay, dataList[self.row!].sevenDays, dataList[self.row!].oneMonth, dataList[self.row!].oneYear]
                }
                else{
                    if let apiData = apiData {
                        destinationVC.apiData = apiData[0]
                        destinationVC.valueList = [apiData[0].oneDay, apiData[0].sevenDays, apiData[0].oneMonth, apiData[0].oneYear]
                    }

                }
            }
            
        }
    }
    
    /*
    Configuring the table view delegate
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isCellData = true
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.row = indexPath.row
        performSegue(withIdentifier: "CryptoDetails", sender: indexPath)
        
    }
    
    /*
    Configuring the table view datasource
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cryptoSymbols.count
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(dataList.count) Items in List"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont.systemFont(ofSize: 25)
        header.tintColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1)
        
        header.textLabel?.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoTableCell", for: indexPath) as! CryptoTableViewCell
        
        let row = indexPath.row
        let tempValue = Float(dataList[row].oneDay.price_change)
        
        cell.symbolLabel.text = dataList[row].id
        cell.nameLabel.text = dataList[row].name
        cell.priceLabel.text = "$\(dataList[row].price)"
        
        if tempValue! > 0 {
            cell.priceLabel.textColor = UIColor(red: 0.00, green: 0.68, blue: 0.71, alpha: 1)
            dataList[row].isPositive = true
        }
        else{
            cell.priceLabel.textColor = UIColor(red: 1.00, green: 0.32, blue: 0.29, alpha: 1)
            dataList[row].isPositive = false
        }
        
        tableView.tableFooterView = UIView(frame: .zero)    // Get rid of extra lines
        tableView.separatorColor = UIColor.white
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return cell
    }
    
    /*
     Update the table when adding or deleting
     */
    func updateData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

/*
Configuring Search Bar
 */
extension CryptoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let symbol = searchBar.text
        
        // Finding if theres a duplicate and replace with new values.
        if dataList.firstIndex(where: {$0.id == symbol}) != nil {
            apiHandler.isPressed = true
        }
        else{
            apiHandler.isPressed = false
        }
        
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
        dataList = data
        updateData()
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
    func getSavedData(_ data: APIFormat) {
        if data.isPressed == false {
            for (i,item) in dataList.enumerated(){
                if data.id == item.id{
                    dataList.remove(at: i)
                }
            }
        }
        
        else{
            dataList.append(data)
        }
    
        print(dataList)
        
        updateData()
    }
    
    
}
