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

protocol BalanceVCDelegate: class {
    func didEditData() -> Balance
    func isEditData() -> Bool
    func doneEditData(balance: Balance)
}


class BalanceEntryViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
//    let categorySelectVC = CategorySelectionViewController()
//    let accountSelectVC = AccountSelectionViewController()
    
    var delegate5: BalanceVCDelegate?
//    var editingAmount = ""
//    var editingCategory = ""
//    var editingAccount = ""
//    var editing
//    
    
    var myList:[String] = []
    var selectedDate = Date()
    var selectedDateStr = ""
    var selectedAmount = ""
    var selectedCategory = "Food"
    var selectedAccount = "Cash"
    var selectedMemo = ""
    var selectedId = 0
    var selectedKey = ""
    var isEditingData: Bool = false
    var editBalanceIndex = 0;
    
    let navColor = UIColor(red:0.40, green:0.60, blue:0.40, alpha:1.0)
    
    let cellName = ["AmountCell", "CategoryCell", "AccountCell", "MemoCell"]
    
    var ref:FIRDatabaseReference?
    var user: FIRUser!
    
    var editBalanceData:Balance? = nil
//    var isEditingBalanceArrayOfIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedDateStr = convertDateToString(date: selectedDate)
        dateLbl.text = selectedDateStr
        navigationController?.navigationBar.barTintColor = navColor
        
//        ref = FIRDatabase.database().reference()
//        user = FIRAuth.auth()?.currentUser
        
        isEditingData = (delegate5?.isEditData())!

        if isEditingData == true {
            editBalanceData = delegate5?.didEditData()
            selectedKey = (editBalanceData?.balanceKey)!
            selectedId = (editBalanceData?.balanceId)!
            selectedDateStr = (editBalanceData?.selectedDate)!
            selectedAmount = String(format:"%.2f",(editBalanceData?.amount)!)
            selectedCategory = (editBalanceData?.category)!
            selectedAccount = (editBalanceData?.account)!
            selectedMemo = (editBalanceData?.memo)!
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        tableView.reloadData()
        let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BalanceEntryTableViewCell
        cell.amountTxt.becomeFirstResponder()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellName[indexPath.section])
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: cellName[indexPath.section], for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName[indexPath.section], for: indexPath) as? BalanceEntryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        if indexPath.section == 0 {
            cell.amountTxt.text = selectedAmount
        }else if indexPath.section == 1 {
            cell.CategoryLbl.text = selectedCategory
        }else if indexPath.section == 2 {
            cell.AccountLbl.text = selectedAccount
        }else if indexPath.section == 3 {
            cell.memoTxt.text = selectedMemo
        }
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
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
        if isEditingData == true {
            updateDate()
            writeDatebase()
            let balance = Balance(balanceKey: selectedKey, balanceId: selectedId, selectedDate: selectedDateStr, amount: Double(selectedAmount)!, category: selectedCategory, account: selectedAccount, memo: selectedMemo)

            delegate5?.doneEditData(balance: balance)
            isEditingData = false
            editBalanceData = nil
        }else{
            updateDate()
            writeDatebase()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateDate() {
        var i:Int = 0
        while i < cellName.count {
            let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! BalanceEntryTableViewCell
            
            if i == 0 {
                selectedAmount = cell.amountTxt.text!
            }else if i == 1 {
                selectedCategory = cell.CategoryLbl.text!
            }else if i == 2 {
                selectedAccount = cell.AccountLbl.text!
            }else {
                selectedMemo = cell.memoTxt.text!
            }
            i = i + 1
        }
    }
    func writeDatebase() {
        
        if selectedAmount != "" {
            if selectedMemo == "" {
                selectedMemo = "None"
            }
            let post = ["date": selectedDateStr,
                        "amount": selectedAmount,
                        "category": selectedCategory,
                        "account": selectedAccount,
                        "memo": selectedMemo] as [String : Any]

            if isEditingData == true {
                ref?.child("users").child(user.uid).child("items").child(selectedKey).updateChildValues(post)
            }else{
                ref?.child("users").child(user.uid).child("items").childByAutoId().updateChildValues(post)
            }
            

        }
    }
    
    func clearDate() {
        
        var i:Int = 0
        while i < cellName.count {
            let cell: BalanceEntryTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! BalanceEntryTableViewCell
            
            if i == 0 {
                cell.amountTxt.text = selectedAmount
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryID" {
            let v = segue.destination as! CategorySelectionViewController
            v.delegate7 = self
            
        } else if segue.identifier == "AccountID" {
            let v = segue.destination as! AccountSelectionViewController
            v.delegate = self
        }
        updateDate()
    }
    
}

extension BalanceEntryViewController: CategorySelectionDelegate, AccountSelectionDelegate  {
    func didSelectedCategory(str:String) {
        selectedCategory = str
    }
    
    func didSelectedAccount(str:String) {
        selectedAccount = str
    }
}

//extension BalanceEntryViewController:   {
//    func didEditData() {
////        selectedAmount = String(format:"%.2f",balance.amount)
////        selectedCategory = balance.category
////        selectedAccount = balance.account
////        selectedMemo = balance.memo
//    }
//}

//    func didEditData() {
//        selectedAmount = String(format:"%.2f",b.amount)
//        selectedCategory = b.category
//        selectedAccount = b.account
//        selectedMemo = b.memo
//    }

