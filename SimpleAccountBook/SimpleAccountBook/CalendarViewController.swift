//
//  CalendarViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    

    
//    private let myiPhoneItems: NSArray = ["iOS8", "iOS7", "iOS6", "iOS5", "iOS4"]
//    private let myAndroidItems: NSArray = ["5.x", "4.x", "2.x", "1.x"]
    
    // Sectionで使用する配列を定義する.
//    private let mySections: NSArray = ["iPhone", "Android"]
    let bBC = BalanceEntryViewController()
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    var balanceArray: [Balance] = []
    var totalAmount = 0.0
    var totalAmounts:[Double] = []
    var dataInSection: [[Balance]] = []
    var sectionIndex:[String] = []
    
//    var sectionArray = [[Balance]]()
    
//    var Datesections: [String] = ["2017/07/01", "2017/07/02"]
    let currentDate = Date()
    
    var currentDateStr = ""
    var selectedDate = Date()
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    
    let outsideMonthColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
    let monthColor = UIColor(red:0.36, green:0.37, blue:0.39, alpha:1.0)
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    let navColor = UIColor(red:0.40, green:0.60, blue:0.40, alpha:1.0)
    
    let formatter = DateFormatter()
    
    var numOfdata:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        readDatabase()
        
        //Setup calendar spacing
        setupCalendarView()
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.blue
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 )
//        tableView.tableHeaderView = headerView
        
        //For segment
        tableView.isHidden = true
        calendarView.isHidden = false
        
        getCurrentDay()
        calendarView.scrollToDate(currentDate)
        
        navigationController?.navigationBar.barTintColor = navColor
        currentDateStr = convertDateToString(date: currentDate)
        balanceArray = [Balance]()
        
//        sectionArray = [myCoatItems, myJyacketItems]
//        sectionIndex = [String]()
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("viewDidAppear!!")
//        calendarView.reloadData()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        calendarView.reloadData()
//    }
    
    func readDatabase() {
        var selectedDateStr:String = ""
        var amount:String = ""
        var category:String = ""
        var account:String = ""
        var memo:String = ""
        var isSameDate:Bool = false
    
        handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String:AnyObject]
            {
                for (key, value) in item {
                    print("\(key) -> \(value)")
                    if key == "date" {
                        selectedDateStr = value as! String
                    }else if key == "account" {
                        account = value as! String
                    }else if key == "amount" {
                        amount = value as! String
                    }else if key == "category" {
                        category = value as! String
                    }else if key == "memo" {
                        memo = value as! String
                    }
                    self.numOfdata += 1
                    
                }

                
                for item in self.sectionIndex{
                    if item == selectedDateStr {
                        isSameDate = true
                        break
                    }
                }
                if isSameDate == false {
                    self.sectionIndex.append(selectedDateStr)
                }else{
                    isSameDate = false
                }
                
                
                let balance = Balance(selectedDate: selectedDateStr, amount: Double(amount)!, category: category, account: account, memo: memo)
                self.balanceArray.append(balance)

            }
        })
        self.calendarView.reloadData()
        print("calendarview reload")
        self.tableView.reloadData()
    }

    func convertDateToString(date:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy/MM/dd"
        
        let dateStr = formatter.string(from: date)

        return dateStr
        
    }
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0;
    }
    
    func getCurrentDay() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        currentYear = calendar.component(.year, from: date)
        currentMonth = calendar.component(.month, from: date)
        currentDay = calendar.component(.day, from: date)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {
            return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
//    func handleCellTotalAmount(view: JTAppleCell?, cellState: CellState, date: Date) {
//        guard let validCell = view as? CustomCell else {
//            return }
//        
//        if sectionIndex.count != 0 {
//            let d = convertDateToString(date: date)
//            for i in 0...sectionIndex.count-1 {
//                if d == sectionIndex[i] {
//                    let total = String(format:"%.2f", totalAmounts[i])
//                    validCell.totalAmountLabel.text = "$\(total)"
//                    validCell.totalAmountLabel.textColor = UIColor.yellow
//                    print("yes\(date) \(total)")
//                }else {
//                    validCell.totalAmountLabel.text = ""
//                    print("no\(date)")
//
//                }
//            }
//        }

//        
//        if cellState.isSelected {
//            validCell.dateLabel.textColor = selectedMonthColor
//        } else {
//            if cellState.dateBelongsTo == .thisMonth {
//                validCell.dateLabel.textColor = monthColor
//            }else{
//                validCell.dateLabel.textColor = outsideMonthColor
//            }
//        }
        
  //  }

    
    //when cell is clicked
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            validCell.selectedView.layer.cornerRadius = 0.5 * validCell.selectedView.bounds.size.width
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    //Year&Month label
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
        
    }
    
    func visibleDate(from visibleDates: DateSegmentInfo) -> Date{
        let date = visibleDates.monthDates.first!.date
        return date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSegmentSelected(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            tableView.isHidden = true
            calendarView.isHidden = false
            calTotalAmount()
//            calendarView.reloadData()
        case 1:
            tableView.isHidden = false
            calendarView.isHidden = true
//            dataInSection.removeAll()
//            sectionIndex.removeAll()
//            balanceArray.removeAll()
//            readDatabase()
            tableView.reloadData()
            
        default:
            break;
        }
    }
    //Caluculate total amount
    func calTotalAmount(){
        for i in 0...dataInSection.count-1 {
            for j in 0...dataInSection[i].count-1 {
                if j == 0 {
                    totalAmount = 0.0
                }
                totalAmount += dataInSection[i][j].amount
                
                if j == dataInSection[i].count-1 {
                    totalAmounts.insert(totalAmount, at: i)
                }

            }
        }
    }
    
    @IBAction func goEntryBtn(_ sender: Any) {
        performSegue(withIdentifier: "BalanceEntrySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BalanceEntrySegue" {
            let balanceEntryVC = segue.destination as! BalanceEntryViewController
            balanceEntryVC.selectedDate = selectedDate
            balanceEntryVC.ref = ref
        }
    }

    //TableView for List
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionIndex.count > 0 {
            for j in 0...balanceArray.count-1 {
                if sectionIndex[section] == balanceArray[j].selectedDate {
                    self.dataInSection[autoAppendTo: section].append(balanceArray[j])
                }
            }
        }
        return dataInSection[section].count
    }
    
    
    //Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionIndex.count
    }
    //Title of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        totalAmount = 0.0
        for index in 0...dataInSection[section].count-1 {
            totalAmount += dataInSection[section][index].amount
        }
        let title = "\(sectionIndex[section]) Total:$\(totalAmount)"
        return title
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListCustomCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

            cell.accountLblForList.text = dataInSection[indexPath.section][indexPath.row].account
            cell.amountLblForList.text = String(format:"%.2f", dataInSection[indexPath.section][indexPath.row].amount)
            cell.categoryLblForList.text = dataInSection[indexPath.section][indexPath.row].category

        cell.imageView?.image = UIImage(named: "FoofImg")
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        print("click")
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
//CalendarViewController end

extension CalendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        cell.totalAmountLabel.text = ""
        print(date)
        
        //Show totalamount
        if sectionIndex.count != 0 {
            let d = convertDateToString(date: date)
            for i in 0...sectionIndex.count-1 {
                if d == sectionIndex[i] {
                    let total = String(format:"%.2f", totalAmounts[i])
                    cell.totalAmountLabel.text = "$\(total)"
                    cell.totalAmountLabel.textColor = UIColor.yellow
                    print("yes\(date) \(total)")
                    break
                }else {
                    cell.totalAmountLabel.text = ""
                    
                }
            }
        }
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
//        handleCellTotalAmount(view: cell, cellState: cellState, date: date)
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: cellState.date)
        let month = calendar.component(.month, from: cellState.date)
        let day = calendar.component(.day, from: cellState.date)
        
        //Mark currentday
        if(year == self.currentYear && month == self.currentMonth && day == self.currentDay){
            cell.todayView.isHidden = false
//            cell.selectedView.layer.cornerRadius = 0.5 * cell.selectedView.bounds.size.width
        }else{
            cell.todayView.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.selectedDate = date
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    //Year&Month label
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BalanceEntrySegue" {
//        }
//    }
}

extension Array where Element: ExpressibleByArrayLiteral {
    
    private mutating func append(to i: Int) {
        while self.count <= i {
            self.append([])
        }
    }
    
    subscript(autoAppendTo i: Int) -> Element {
        mutating get {
            self.append(to: i)
            return self[i]
        }
        set {
            self.append(to: i)
            self[i] = newValue
        }
    }
    
}


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

