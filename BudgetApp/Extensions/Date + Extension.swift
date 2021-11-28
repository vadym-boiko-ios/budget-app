//
//  DateFormatter.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 28.11.2021.
//

import Foundation


extension Date {
    //DoesRelativeDateFormatting with a custom style
    func formatDate() -> String {
     
        // Setup the relative formatter
        let firstDateFormatter = DateFormatter()
        firstDateFormatter.doesRelativeDateFormatting = true
        firstDateFormatter.dateStyle = .short
        firstDateFormatter.timeStyle = .short
        
        // Setup the non-relative formatter
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateStyle = .short
        secondDateFormatter.timeStyle = .short
        
        // Get the result of both formatters
        let first = firstDateFormatter.string(from: self)
        let second = secondDateFormatter.string(from: self)
        
        // If the results are the same then it isn't a relative date - custom formatter.
        // If different, return the relative result.
        if (first == second) {
            let finalDataFormatter = DateFormatter()
            finalDataFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm")
            return finalDataFormatter.string(from: self)
        } else {
            return first
        }
    }
}
    
