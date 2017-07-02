//
//  AccountSelectionViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-02.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class AccountSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var accountTableView: UITableView!
    
    var accountArray:[String] = ["Cash","Bank"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
        
        accountTableView.delegate = self
        accountTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        cell.textLabel?.text = "\(accountArray[indexPath.row])"
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:IndexPath) {
        print("click")
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
