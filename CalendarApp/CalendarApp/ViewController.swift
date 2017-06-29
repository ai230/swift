//
//  ViewController.swift
//  CalendarApp
//
//  Created by AiYamamoto on 2017-06-24.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
    }
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0;
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
    
        func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
            guard let validCell = view as? CustomCell else { return }
            if cellState.isSelected {
                validCell.selectedView.isHidden = false
            } else {
                validCell.selectedView.isHidden = true
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: JTAppleCalendarViewDataSource{
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

extension ViewController: JTAppleCalendarViewDelegate{
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else { return }
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else { return }
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
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
