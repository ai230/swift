//
//  CategorySelectionViewController.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-02.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

protocol CategorySelectionDelegate: class {
    func didSelectedCategory(str:String)
}

class CategorySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    var delegate: CategorySelectionDelegate?
    var categoryArray:[String] = ["Food","House","Income"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = "\(categoryArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        //delegate give item to BalanceEntryView
        delegate?.didSelectedCategory(str: categoryArray[indexPath.row])
        //close
        navigationController?.popViewController(animated: true)
    }
    
    //Height of Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}
