//
//  CryptoDetailsController.swift
//  crypton
//
//  Created by Jason Chong on 3/24/21.
//

import UIKit
import Charts

protocol CryptoDetailsDelegate {
    func getSavedData(_ data: APIFormat)
}

class MarkerView: UIView {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

class CryptoDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate,ChartViewDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var segmentControlBar: UISegmentedControl!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var apiData: APIFormat?
    var delegate: CryptoDetailsDelegate?
    
    var lineChartEntry: [ChartDataEntry] = []
    
    let markerView = MarkerView()
    
    let nameList = ["1 Day", "1 Week", "1 Month", "1 Year"]
    var valueList: [Details]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
            
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        
        setLabels()
        
        setButtonColor()
        
        graph(100)
        
        settingSegmentBarUI()
    }
    
    func setLabels(){
        symbolLabel.text = apiData!.symbol
        nameLabel.text = apiData!.name
        
        if apiData!.isPositive == true{
            priceLabel.text = "$\(apiData!.price) (+$\(String(format: "%.2f", Float(apiData!.oneDay.price_change)!)))"
            priceLabel.textColor = UIColor(red: 0.00, green: 0.68, blue: 0.71, alpha: 1)
        }
        else{
            priceLabel.text = "$\(apiData!.price) (-$\(String(format: "%.2f", abs(Float(apiData!.oneDay.price_change)!))))"
            priceLabel.textColor = UIColor(red: 1.00, green: 0.32, blue: 0.29, alpha: 1)
        }
    }
    
    func setButtonColor(){
        guard let buttonHasValue = apiData?.isPressed else{
            return
        }
        if buttonHasValue == true{
            saveButton.tintColor = UIColor.green
        }
        else{
            saveButton.tintColor = UIColor.gray
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print(markerView.valueLabel.text)
//        markerView.dateLabel.text = "hello"
//        markerView.center = CGPointMake(graphPoint.x, markerView.center.y)
//        markerView.isHidden = false
        var priceChange:Double!
        
        print(entry)
        priceChange =  entry.y - Double(apiData!.price)!
        if entry.y < Double(apiData!.price)!{
            priceLabel.textColor = UIColor(red: 1.00, green: 0.32, blue: 0.29, alpha: 1)
            priceLabel.text = "\(String(format: "$%.2f", entry.y)) (\(String(format: "-$%.2f", abs(priceChange))))"
        }
        else{
            priceLabel.textColor = UIColor(red: 0.00, green: 0.68, blue: 0.71, alpha: 1)
            priceLabel.text = "\(String(format: "$%.2f", entry.y)) (\(String(format: "+$%.2f", priceChange)))"
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if apiData!.isPressed == nil {
            apiData!.isPressed = false
        }
        
        if let isPressed = apiData!.isPressed {
            if isPressed {
                saveButton.tintColor = UIColor.gray
                apiData!.isPressed = false
                
            }
            else {
                saveButton.tintColor = UIColor.green
                apiData!.isPressed = true
            }
            
            delegate?.getSavedData(apiData!)
            
        }
    }
    
    @IBAction func segmentPressed(_ sender: Any) {
        setLabels()    // Reset the price when switching graphs
                
        
        switch segmentControlBar.selectedSegmentIndex {
        case 0:
            print("Case 0")
            graph(24)
        case 1:
            print("Case 1")
            graph(28)
        case 2:
            print("Case 2")
            graph(30)
        case 3:
            print("Case 3")
            graph(12)
        default:
            print("Error with switch statements")
        }
    }
    
    func graph(_ time: Int){
        // Grabbing the date to set the xAxis on graph
//        standardTime(time)
        
        lineChartEntry = []     // Resetting the graph values
        
        // Settig the UI
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.animate(xAxisDuration: 1)
        
        for i in 0...time{
            let value = ChartDataEntry(x: Double(i), y: Double.random(in: 0...Double(apiData!.price)! * 1.5))
            lineChartEntry.append(value)
        }
        
        let line = LineChartDataSet(entries: lineChartEntry)
        
        // Setting the UI for the line
        line.drawCirclesEnabled = false
        line.lineWidth = 2
        line.drawValuesEnabled = false
        line.highlightColor = UIColor.white
        line.highlightLineWidth = 1
        
        let data = LineChartData(dataSet: line)

        lineChartView.data = data
        
    }
    
    func settingSegmentBarUI() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControlBar.setTitleTextAttributes(titleTextAttributes, for:.normal)

    }
    
    
    /*
     Setting up the Table View Cell
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Stats Price Change"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont.systemFont(ofSize: 25)
        header.tintColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1)
        
        header.textLabel?.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        
        header.textLabel?.textAlignment = .left
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! SecondVCCell
        
        let row = indexPath.row
        
        cell.timeLabel.text = nameList[row]
        var tempValue = Float(valueList[row].price_change)
        if tempValue! > 0{
            cell.valueLabel.textColor = UIColor(red: 0.00, green: 0.68, blue: 0.71, alpha: 1)
            cell.valueLabel.text = "\(String(format: "+$%.2f", tempValue!)) (\(String(format: "%.2f", Float(valueList[row].price_change_pct)! * 100))%)"

        }
        else{
            tempValue = abs(tempValue!)
            cell.valueLabel.textColor = UIColor(red: 1.00, green: 0.32, blue: 0.29, alpha: 1)
            cell.valueLabel.text = "\(String(format: "-$%.2f", tempValue!)) (\(String(format: "%.2f", Float(valueList[row].price_change_pct)! * 100))%)"
        }
        
        tableView.tableFooterView = UIView(frame: .zero)    // Get rid of extra lines
        tableView.separatorColor = UIColor.white
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return cell
    }
    
//    func standardTime(_ time: Int) -> Int{
//        let date = NSDate()
//        let calendar = NSCalendar.current
//        let hour = calendar.component(.hour, from: date as Date)
//        let minute = calendar.component(.minute, from: date as Date)
//
//        if time == 24{
//            for i in 0...time{
//
//            }
//        }
//    }
    
    
}
