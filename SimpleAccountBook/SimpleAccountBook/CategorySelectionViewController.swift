//
//  CategorySelectionViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-02.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

//TODO:Delete and add new one, show old one
import UIKit
import Firebase

protocol CategorySelectionDelegate: class {
    func didSelectedCategory(str:String)
}

class CategorySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    var delegate7: CategorySelectionDelegate?
    var categoryArray:[String] = []
    
    var user: FIRUser!
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?

    var tf = UITextField(frame: CGRect(x: 20, y: 0, width: 300, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser

        readDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readDatabase() {
        var sameCategory = false
        if user != nil {
            handle = ref?.child("users").child(user.uid).child("category").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String
                {
                    if self.categoryArray.count == 0 {
                        self.categoryArray.append(item)
                    }
                    for i in 0...self.categoryArray.count-1 {
                        if self.categoryArray[i] == item {
                            sameCategory = true
                            break
                        }
                    }
                    if sameCategory == false {
                        self.categoryArray.append(item)
                        
                    }else{
                        sameCategory = false
                    }
                    
                }
                self.categoryTableView.reloadData()
            })
        }
    }
    
    func updateDatabase() {
        ref?.child("users").child(user.uid).updateChildValues(["category": categoryArray])
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        print("categoryArray:\(categoryArray)")
        if indexPath.row < categoryArray.count {
            cell.textLabel?.text = "\(categoryArray[indexPath.row])"
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.removeFromSuperview()
        } else {
            tf.placeholder = "Enter new category here"
            tf.font = UIFont.systemFont(ofSize: 15)
            tf.tag = indexPath.row
            cell.addSubview(tf)
            
            
            let addBtn = UIButton(type: .custom)
            addBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            addBtn.addTarget(self, action: #selector(CategorySelectionViewController.accessoryButtonTapped), for: .touchUpInside)
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
            var sameCategory = false
            if self.categoryArray.count == 0 {
                self.categoryArray.append(tf.text!)
                updateDatabase()
                tf.text = ""
                categoryTableView.reloadData()
            }else{
                for i in 0...self.categoryArray.count-1 {
                    if self.categoryArray[i] == tf.text! {
                        sameCategory = true
                        break
                    }
                }
                
                if sameCategory == false {
                    categoryArray.append(tf.text!)
                    updateDatabase()
                    tf.text = ""
                    categoryTableView.reloadData()
                }else{
                    self.showAlert("The category name is exist")
                    tf.text = ""
                }
            }
        }
    }
    
    //cell clicked
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        if indexPath.row == categoryArray.count {
            
            print("click")

        } else {
            //delegate give item to BalanceEntryView
            delegate7?.didSelectedCategory(str: categoryArray[indexPath.row])
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
            categoryArray.remove(at: indexPath.row)
            print("delete:\(categoryArray)")
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
