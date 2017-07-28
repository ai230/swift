
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
import FirebaseAuth

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var viewForTableView: UIView!
    @IBOutlet weak var viewForCalView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var calTableView: UITableView!

    @IBOutlet weak var naviTitle: UINavigationItem!
    
    @IBOutlet weak var naviTitleCal: UINavigationItem!
//    var delegate3: CalendarVCDelegate?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var user: FIRUser!
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    
    var balanceArray: [Balance] = []
    var dataInSection: [[Balance]] = []
    var sectionIndex:[String] = []
    var balanceArrayDay: [Balance] = []
    
    var totalAmount = 0.0
    var totalAmounts:[Double] = []

    let currentDate = Date()
    var currentDateStr = ""
    var selectedDate = Date()
    var selectedDateString :String = ""
    var showDate = Date()
    
    var selectedAmount = ""
    var selectedCategory = ""
    var selectedAccount = ""
    var selectedMemo = ""
    var selectedKey = ""
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    
    let outsideMonthColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
    let monthColor = UIColor(red:0.36, green:0.37, blue:0.39, alpha:1.0)
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    let navColor = UIColor(red:0.40, green:0.60, blue:0.40, alpha:1.0)
    let totalAmountColor = UIColor(red:1.00, green:0.66, blue:0.00, alpha:1.0)
    
    let formatter = DateFormatter()
    
    var numOfdata:Int = 0
    var isEditingData: Bool = false
    var editBalanceData:Balance? = nil
    var isEditingBalanceArrayOfIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        readDatabase()
        
        //Setup calendar spacing
        setupCalendarView()
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        calTableView.delegate = self
        calTableView.dataSource = self
        
        //For segment
//        tableView.isHidden = true
//        calendarView.isHidden = false
//        calTableView.isHidden = false
        
//        viewForCalView.isHidden = false
//        viewForTableView.isHidden = true
        
        getCurrentDay()
        calendarView.scrollToDate(currentDate)
        
        navigationController?.navigationBar.barTintColor = navColor
        currentDateStr = convertDateToString(date: currentDate)
        balanceArray = [Balance]()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        editBalanceData = nil
        dataInSection.removeAll()
        tableView.reloadData()
        calendarView.reloadData()
        calCreateBalanceArrayDay()
        calTableView.reloadData()
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: showDate)
        calendarView.scrollToDate(previousMonth!)
        showDate = previousMonth!
        dataInSection.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func goToNextMonth(_ sender: Any) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: showDate)
        calendarView.scrollToDate(nextMonth!)
        showDate = nextMonth!
        dataInSection.removeAll()
        tableView.reloadData()
    }
    
    func readDatabase() {
        if user != nil {
            handle = ref?.child("users").child(user.uid).child("items").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? [String:AnyObject]
                {
                    let snapshotKey = snapshot.key
                    self.updateData(item: item, snapshotKey: snapshotKey)
                }
                self.calendarView.reloadData()
            })
        
        
            handle = ref?.child("users").child("01").child("items").observe(.childRemoved, with: { (snapshot) in
                if let item = snapshot.value as? [String:AnyObject]
                {
                    let snapshotKey = snapshot.key
                    self.removeData(item: item, snapshotKey: snapshotKey)
                }
                self.calTableView.reloadData()
                self.calendarView.reloadData()
                self.tableView.reloadData()
                
            })
        
        }
        
    }

    func updateData(item: [String: AnyObject],snapshotKey: String) {
        var balanceId: Int = 0
        var selectedDateStr:String = ""
        var amount:String = ""
        var category:String = ""
        var account:String = ""
        var memo:String = ""
        
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

        balanceId = self.balanceArray.count
        let balance = Balance(balanceKey: snapshotKey, balanceId: balanceId, selectedDate: selectedDateStr, amount: Double(amount)!, category: category, account: account, memo: memo)
        self.balanceArray.append(balance)
        let d = convertDateToString(date: selectedDate)
        if balance.selectedDate == d {
         balanceArrayDay.append(balance)
        }
        calTableView.reloadData()
    }
    
    func removeData(item: [String: AnyObject],snapshotKey: String) {
        var selectedDateStr:String
        var amount:String = ""
        var category:String = ""
        var account:String = ""
        var memo:String = ""
        
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
        
        for index in 0...balanceArray.count-1 {
            if snapshotKey == balanceArray[index].balanceKey {
                balanceArray.remove(at: index)
                break
            }
        }
        for index1 in 0...dataInSection.count-1 {
            for index2 in 0...dataInSection[index1].count-1 {
                if snapshotKey == dataInSection[index1][index2].balanceKey {
                    if dataInSection[index1].count == 1 {
                        sectionIndex.remove(at: index1)
                    }
                    dataInSection.removeAll()
                    break
                }

            }
        }
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
        showDate = visibleDates.monthDates.first!.date

        self.formatter.dateFormat = "yyyy"
        let year = self.formatter.string(from: showDate)
        
        self.formatter.dateFormat = "MMMM"
        let month = self.formatter.string(from: showDate)
        
        self.naviTitle.title = "\(year) \(month)"
        self.naviTitleCal.title = "\(year) \(month)"
        
    }
    
    func visibleDate(from visibleDates: DateSegmentInfo) -> Date{
        let date = visibleDates.monthDates.first!.date
        return date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                self.dismiss(animated: true, completion: {})

//                try FIRAuth.auth()?.signOut()
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarID")
//                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
          print("user:nil")
        }
    }
    
    @IBAction func didSegmentSelected(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
//            tableView.isHidden = true
//            calendarView.isHidden = false
//            calTableView.isHidden = false
            viewForCalView.isHidden = false
            viewForTableView.isHidden = true
            dataInSection.removeAll()
            calCreateBalanceArrayDay()
            calTableView.reloadData()
        case 1:
//            tableView.isHidden = false
//            calendarView.isHidden = true
//            calTableView.isHidden = true
            viewForCalView.isHidden = true
            viewForTableView.isHidden = false
            dataInSection.removeAll()
            tableView.reloadData()
        default:
            break;
        }
    }
    
    
    @IBAction func goEntryBtn(_ sender: Any) {
        performSegue(withIdentifier: "BalanceEntrySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BalanceEntrySegue" {
            let balanceEntryVC = segue.destination as! BalanceEntryViewController
            balanceEntryVC.delegate5 = self
            balanceEntryVC.selectedDate = selectedDate
            balanceEntryVC.ref = ref
            balanceEntryVC.user = user
        }
    }

    //TableView for List
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0 {
            if sectionIndex.count > 0 {
                for j in 0...balanceArray.count-1 {
                    if sectionIndex[section] == balanceArray[j].selectedDate {
                        self.dataInSection[autoAppendTo: section].append(balanceArray[j])
                    }
                }
            }
            return dataInSection[section].count
        }else{
            
            if balanceArray.count != 0 {
//                totalAmount = 0.0
//                let d = convertDateToString(date: selectedDate)
//                for item in balanceArray {
//                    if d == item.selectedDate {
//                        totalAmount += item.amount
//                        balanceArrayDay.append(item)
//                    }
//                }
            }
            return balanceArrayDay.count
        }
    }
    
    
    //Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {

        let month = Calendar.current.component(.month, from: showDate)
        var isSameDate = false
        
        if balanceArray.count > 0 {
            sectionIndex.removeAll()
            for e in balanceArray {
                let d = e.selectedDate
                let start = d.index(d.startIndex, offsetBy: 6)
                let end = d.index(d.endIndex, offsetBy: -3)
                let range = start..<end
                
                let m = Int(d.substring(with: range))
                if m == month {
                    sectionIndex.append(e.selectedDate)
                    break
                }
            }
            for i in 0..<balanceArray.count {
                
                let d = balanceArray[i].selectedDate
                let start = d.index(d.startIndex, offsetBy: 6)
                let end = d.index(d.endIndex, offsetBy: -3)
                let range = start..<end
                
                let m = Int(d.substring(with: range))
                if m == month {
                    for j in 0..<sectionIndex.count {
                        if sectionIndex[j] == balanceArray[i].selectedDate {
                            isSameDate = true
                        }
                    }
                    if isSameDate == false {
                        
                        sectionIndex.append(balanceArray[i].selectedDate)
                        sectionIndex.sort()
                    }
                    isSameDate = false
                }
            }
        }
        
        
        if tableView.tag == 0 {
            return sectionIndex.count
        } else {
            return 1
        }
    }
    
    //Title of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if balanceArray.count > 0 {
            if tableView.tag == 0 {
                totalAmount = 0.0
                for index in 0...dataInSection[section].count-1 {
                    totalAmount += dataInSection[section][index].amount
                }
                let title = "\(sectionIndex[section]) Total:$\(totalAmount)"
                return title
            } else {
                let d:String = convertDateToString(date: selectedDate)
                return "\(d)"
            }
        }else{
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListCustomCell  else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            
            cell.accountLblForList.text = dataInSection[indexPath.section][indexPath.row].account
            cell.amountLblForList.text = "$\(String(format:"%.2f", dataInSection[indexPath.section][indexPath.row].amount))"
            cell.categoryLblForList.text = dataInSection[indexPath.section][indexPath.row].category
            
            cell.imageView?.image = UIImage(named: "FoofImg")
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalTableCell", for: indexPath) as? CalCustomCell  else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            
            cell.amountLblForCal.text = "$\(String(format:"%.2f", balanceArrayDay[indexPath.row].amount))"
            cell.categoryLblForCal.text = balanceArrayDay[indexPath.row].category
            cell.accountLblForCal.text = balanceArrayDay[indexPath.row].account
            
            return cell
            
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
//        
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView.tag == 0 {
            //So when it is section == 0, navibar hides section title
            if section == 0 {
                return 28
            }else{
                return 8
            }
//        } else {
//            return 10
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        isEditingData = true
        if tableView.tag == 0 {
            
            editBalanceData = dataInSection[indexPath.section][indexPath.row]
            print("click tag0")

        }else{
            editBalanceData = balanceArrayDay[indexPath.row]
            print("click tag1")
        }
    }
    
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = dataInSection[indexPath.section][indexPath.row].balanceKey
            ref?.child("users").child("01").child("items").child(key).removeValue()
//            dataInSection.removeAll()
        }
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func calCreateBalanceArrayDay() {
        balanceArrayDay = []
        let d = convertDateToString(date: selectedDate)
        
        for item in balanceArray {
            if item.selectedDate == d {
                balanceArrayDay.append(item)
            }
        }
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
        if balanceArray.count != 0 {
            totalAmount = 0.0
            let d = convertDateToString(date: date)
            for item in balanceArray {
                if d == item.selectedDate {
                    totalAmount += item.amount
                }
            }
            let total = String(format:"%.2f", totalAmount)
            cell.totalAmountLabel.text = "$\(total)"
            cell.totalAmountLabel.textColor = totalAmountColor
            if(totalAmount == 0) {
                cell.totalAmountLabel.text = ""
            }
        }
        
//        if dataInSection.count != 0 {
//            let d = convertDateToString(date: date)
//            for index in 0...dataInSection.count {
//                for j in 0...dataInSection[index].count {
//                    if d == dataInSection[index][j].selectedDate {
//                        totalAmount += dataInSection[index][j].amount
//                    }
//                }
//            }
//            let total = String(format:"%.2f", totalAmount)
//            cell.totalAmountLabel.text = "$\(total)"
//            cell.totalAmountLabel.textColor = UIColor.yellow
//        }else{
//            cell.totalAmountLabel.text = ""
//        }
    
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: cellState.date)
        let month = calendar.component(.month, from: cellState.date)
        let day = calendar.component(.day, from: cellState.date)
        
        //Mark currentday
        if(year == self.currentYear && month == self.currentMonth && day == self.currentDay){
            cell.todayView.isHidden = false
            cell.todayView.layer.cornerRadius = 0.5 * cell.selectedView.bounds.size.width
        }else{
            cell.todayView.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.selectedDate = date
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        calCreateBalanceArrayDay()
        calTableView.reloadData()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    //Year&Month label
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
        
    }
    
    
}
extension CalendarViewController: BalanceVCDelegate  {
 
    func didEditData() -> Balance{
        return editBalanceData!
    }
    
    func isEditData() -> Bool {
        return isEditingData
    }
    
    func doneEditData(balance: Balance) {
        isEditingData = false
        //replace
        let balance = balance
        balanceArray[balance.balanceId] = balance
    }
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

//extension Date {
//    func getNextMonth(aDate:Date) -> Date? {
//        return Calendar.current.date(byAdding: .month, value: 1, to: aDate)
//    }
//    
//    func getPreviousMonth(date:Date) -> Date? {
//        return Calendar.current.date(byAdding: .month, value: -1, to: aDate)
//    }
//}

