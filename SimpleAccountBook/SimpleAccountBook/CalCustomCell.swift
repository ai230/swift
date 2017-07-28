//
//  CalCustomCell.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-19.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class CalCustomCell: UITableViewCell {

    @IBOutlet weak var amountLblForCal: UILabel!
    @IBOutlet weak var accountLblForCal: UILabel!
    @IBOutlet weak var categoryLblForCal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
