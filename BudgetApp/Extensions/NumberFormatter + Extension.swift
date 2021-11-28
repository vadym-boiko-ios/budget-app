//
//  NumberFormatter + Extension.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 28.11.2021.
//

import Foundation

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
}
