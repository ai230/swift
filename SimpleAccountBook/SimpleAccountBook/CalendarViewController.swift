//
//  CalendarViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var balanceArray: [Balance]? = nil
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup calendar spacing
        setupCalendarView()
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
        
        getCurrentDay()
        calendarView.scrollToDate(currentDate)
        
        navigationController?.navigationBar.barTintColor = navColor
        currentDateStr = convertDateToString(date: currentDate)
        balanceArray = [Balance]()
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
    
    @IBAction func goEntryBtn(_ sender: Any) {
        performSegue(withIdentifier: "BalanceEntrySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BalanceEntrySegue" {
            let balanceEntryVC = segue.destination as! BalanceEntryViewController
            balanceEntryVC.selectedDate = selectedDate
            balanceEntryVC.balanceArray = balanceArray
        }
    }
    
}

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
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: cellState.date)
        let month = calendar.component(.month, from: cellState.date)
        let day = calendar.component(.day, from: cellState.date)
        
        //Mark currentday
        if(year == self.currentYear && month == self.currentMonth && day == self.currentDay){
//            cell.dateLabel.textColor = UIColor.red
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 0.5 * cell.bounds.size.width
            cell.layer.borderColor = UIColor.gray.cgColor
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

