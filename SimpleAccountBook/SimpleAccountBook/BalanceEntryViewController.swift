//
//  BalanceEntryViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BalanceEntryViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
//    var balanceArray: [Balance]?
    var balanceArray: [Balance]? = nil
    var myList:[String] = []
    var selectedDate = Date()
    let navColor = UIColor(red:0.40, green:0.60, blue:0.40, alpha:1.0)
    
//    let rows = ["Amount", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let cellName = ["AmountCell", "CategoryCell", "AccountCell", "MemoCell"]
    
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = navColor
        
        dateLbl.text = convertDateToString(date: selectedDate);
        
        readDatabase()
    }

    override func viewDidAppear(_ animated: Bool) {
        let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BalanceEntryTableViewCell
        cell.amountTxt.becomeFirstResponder()
    }
    
    func readDatabase() {
        var selectedDateStr:String = ""
        var amount:String = ""
        var category:String = ""
        var account:String = ""
        var memo:String = ""
        
        ref = FIRDatabase.database().reference()
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
                }
                
                let balance = Balance(selectedDate: selectedDateStr, amount: Double(amount)!, category: category, account: account, memo: memo)
                self.balanceArray?.append(balance)
            }
        })
    }
    
    func convertDateToString(date:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy/MM/dd"
        
        let dateStr = formatter.string(from: date)
        
        return dateStr
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return cellName.count
//    }
//    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellName[indexPath.section])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName[indexPath.section], for: indexPath)
//        cell.textLabel?.text = rows[indexPath.section]
        
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:IndexPath) {
        print("click")
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //Save Data to Balance class
    @IBAction func saveBtn(_ sender: Any) {
        
        uploadDate()
//        clearDate()
        navigationController?.popViewController(animated: true)
    }
    
    func uploadDate() {
        var selectedDateStr:String = ""
        var amount:String = ""
        var category:String = ""
        var account:String = ""
        var memo:String = ""
        
        var i:Int = 0
        while i < cellName.count {
            let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! BalanceEntryTableViewCell
            
            if i == 0 {
                amount = cell.amountTxt.text!
            }else if i == 1 {
                category = cell.CategoryLbl.text!
            }else if i == 2 {
                account = cell.AccountLbl.text!
            }else {
                memo = cell.memoTxt.text!
            }
            i = i + 1
        }
        selectedDateStr = convertDateToString(date: selectedDate)
        
        let post = ["date": selectedDateStr,
                    "amount": amount,
                    "category": category,
                    "account": account,
                    "memo": memo] as [String : Any]
        
        ref?.child("list").childByAutoId().setValue(post)
        

        
//        let balance = Balance(selectedDate: selectedDate, amount: Double(amount)!, category: category, account: account, memo: memo)
//        balanceArray?.append(balance)
    }
    
    func clearDate() {
        
        var i:Int = 0
        while i < cellName.count {
            let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! BalanceEntryTableViewCell
            
            if i == 0 {
                cell.amountTxt.text = ""
            }else if i == 1 {
                cell.CategoryLbl.text = "Food"
            }else if i == 2 {
                cell.AccountLbl.text = "Cash"
            }else {
                cell.memoTxt.text = ""
            }
            i = i + 1
        }
    }
}
