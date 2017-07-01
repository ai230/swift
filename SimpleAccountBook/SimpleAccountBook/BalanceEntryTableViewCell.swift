//
//  BalanceEntryTableViewCell.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class BalanceEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var CategoryLbl: UILabel!
    @IBOutlet weak var AccountLbl: UILabel!
    @IBOutlet weak var memoTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
