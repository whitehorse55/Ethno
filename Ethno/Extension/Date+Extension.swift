//
//  Date+Extension.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/12.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation

extension Date{
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }

}
