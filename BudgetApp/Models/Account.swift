//
//  Account.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 26.11.2021.
//

import Foundation

struct Account {
    let name: String
    var list: [Transaction]
    var sum: Double {
        self.list.map{$0.amount}.reduce(0,+)
    }
}




