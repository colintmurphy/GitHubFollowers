//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 7/1/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

extension Date {
    
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

// visit: https://www.nsdateformatter.com for date formats
