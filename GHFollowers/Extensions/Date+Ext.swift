//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by William Maguire on 4/7/21.
//

import Foundation

extension Date {
  
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
