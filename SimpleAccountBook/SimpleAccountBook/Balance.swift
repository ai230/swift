//
//  Balance.swift
//  SimpleAccountBook
//
//  Created by AiYamamoto on 2017-06-30.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import Foundation

class Balance {
    var balanceKey:String
    var balanceId:Int
    var selectedDate:String
    var amount:Double
    var category:String
    var account:String
    var memo:String
    
    init(balanceKey: String, balanceId: Int, selectedDate: String, amount: Double, category: String, account: String, memo: String) {
        self.balanceKey = balanceKey
        self.balanceId = balanceId
        self.selectedDate = selectedDate
        self.amount = amount
        self.category = category
        self.account = account
        self.memo = memo
    }
}
