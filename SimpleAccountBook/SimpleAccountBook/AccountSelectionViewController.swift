//
//  AccountSelectionViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-02.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit
import Firebase

protocol AccountSelectionDelegate {
    func didSelectedAccount(str:String)
}

class AccountSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var accountTableView: UITableView!
    
    var delegate: AccountSelectionDelegate?
    
    var accountArray:[String] = []
    var user: FIRUser!
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    
    var tf = UITextField(frame: CGRect(x: 20, y: 0, width: 300, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
        
        accountTableView.delegate = self
        accountTableView.dataSource = self
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        readDatabase()
//        if self.accountArray.count == 0 {
//            self.accountArray.append("Cash")
//            self.accountArray.append("Bank")
//            self.updateDatabase()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readDatabase() {
        var sameAccount = false
        if user != nil {
            handle = ref?.child("users").child(user.uid).child("account").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String
                {
                    if self.accountArray.count == 0 {
                        self.accountArray.append(item)
                    }
                        for i in 0...self.accountArray.count-1 {
                            if self.accountArray[i] == item {
                                sameAccount = true
                                break
                            }
                        }
                        if sameAccount == false {
                            self.accountArray.append(item)
                            
                        }else{
                            sameAccount = false
                    }
                    
                }
                self.accountTableView.reloadData()
            })
        }
    }
    
    func updateDatabase() {
        ref?.child("users").child(user.uid).updateChildValues(["account": accountArray])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count+1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        if indexPath.row < accountArray.count {
            cell.textLabel?.text = "\(accountArray[indexPath.row])"
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.removeFromSuperview()
        } else {
            
            tf.placeholder = "Enter new account here"
            tf.font = UIFont.systemFont(ofSize: 15)
            tf.tag = indexPath.row
            cell.addSubview(tf)
            
            
            let addBtn = UIButton(type: .custom)
            addBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            addBtn.addTarget(self, action: #selector(AccountSelectionViewController.accessoryButtonTapped), for: .touchUpInside)
            addBtn.setImage(UIImage(named: "AddIcon"), for: .normal)
            addBtn.contentMode = .scaleAspectFit
            cell.accessoryView = addBtn as UIView

            // then set it as cellAccessoryType
            cell.accessoryView = addBtn
            
        }
        return cell
    }
    
    func accessoryButtonTapped(){
        //If it is exist it show alert
        if tf.text! != ""{
            var sameAccount = false
            if self.accountArray.count == 0 {
                self.accountArray.append(tf.text!)
                updateDatabase()
                tf.text = ""
                accountTableView.reloadData()
            }else{
                for i in 0...self.accountArray.count-1 {
                    if self.accountArray[i] == tf.text! {
                        sameAccount = true
                        break
                    }
                }
                
                if sameAccount == false {
                    accountArray.append(tf.text!)
                    updateDatabase()
                    tf.text = ""
                    accountTableView.reloadData()
                }else{
                    self.showAlert("The account name is exist")
                    tf.text = ""
                }
            }
        }
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        if indexPath.row == accountArray.count {
            
            print("click")
        }else{
            //delegate give item to BalanceEntryView
            delegate?.didSelectedAccount(str: accountArray[indexPath.row])
            //close
            navigationController?.popViewController(animated: true)
        }
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            accountArray.remove(at: indexPath.row)
            updateDatabase()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
