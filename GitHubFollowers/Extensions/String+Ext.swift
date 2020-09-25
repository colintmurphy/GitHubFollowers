//
//  String+Ext.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 7/1/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

/// code commented bc "decoder.dateDecodingStrategy = .iso8601" does work for us (String -> Date), but could be useful in future

/*
import UIKit

extension String {
 
    func convertToDate() -> Date? {
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
 
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
 */

