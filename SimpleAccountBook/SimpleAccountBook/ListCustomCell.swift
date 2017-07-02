//
//  ListCustomCell.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-07-01.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class ListCustomCell: UITableViewCell {

    @IBOutlet weak var amountLblForList: UILabel!
    @IBOutlet weak var accountLblForList: UILabel!
    @IBOutlet weak var categoryLblForList: UILabel!
    @IBOutlet weak var imageViewForList: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
