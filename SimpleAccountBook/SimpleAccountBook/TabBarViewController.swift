//
//  TabBarViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TabBarViewController: UITabBarController {

//    var user: FIRUser!
//    var balanceArrayInTabBar: [Balance] = []
//    var sectionIndex:[String] = []
//    var ref:FIRDatabaseReference?
//    var handle:FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        readDatabase()
        
//        let calendarVC = self.tabBarController?.viewControllers?[1] as! CalendarViewController
//        calendarVC.balanceArray = balanceArrayInTabBar
//        let balanceEntryVC = self.tabBarController?.viewControllers?[1] as! BalanceEntryViewController
//        balanceEntryVC.ref = ref
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func addBalance() {
//        let balance : Balance
//        self.balanceArrayInTabBar.append(balance)
//    }
    
//    func readDatabase() {
//        var balanceId: Int = 0
//        var selectedDateStr:String = ""
//        var amount:String = ""
//        var category:String = ""
//        var account:String = ""
//        var memo:String = ""
//        var isSameDate:Bool = false
//        ref = FIRDatabase.database().reference()
//        handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
//            if let item = snapshot.value as? [String:AnyObject]
//            {
//                for (key, value) in item {
//                    print("\(key) -> \(value)")
//                    if key == "date" {
//                        selectedDateStr = value as! String
//                    }else if key == "account" {
//                        account = value as! String
//                    }else if key == "amount" {
//                        amount = value as! String
//                    }else if key == "category" {
//                        category = value as! String
//                    }else if key == "memo" {
//                        memo = value as! String
//                    }
////                    self.numOfdata += 1
//                    
//                }
//                
//                for item in self.sectionIndex{
//                    if item == selectedDateStr {
//                        isSameDate = true
//                        break
//                    }
//                }
//                if isSameDate == false {
//                    self.sectionIndex.append(selectedDateStr)
//                }else{
//                    isSameDate = false
//                }
//                
//                //                (self.tabBarController: TabBarViewController).addBalance()
//                balanceId = self.balanceArrayInTabBar.count
//                let balance = Balance(balanceId: balanceId, selectedDate: selectedDateStr, amount: Double(amount)!, category: category, account: account, memo: memo)
//                self.balanceArrayInTabBar.append(balance)
//                
//            }
////            self.calendarView.reloadData()
////            print("calendarview reload")
//        })
////        self.tableView.reloadData()
//    }
    
}
