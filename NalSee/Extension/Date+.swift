//
//  Date+.swift
//  NalSee
//
//  Created by 홍정민 on 7/19/24.
//

import Foundation

extension Date {
    var toTimeInterval: Int {
        return Int(self.timeIntervalSince1970)
    }
    
    var sixWeekDays: [Date] {
        var list: [Date] = []
        let today = Calendar.current.startOfDay(for: self)
        list.append(today)
        
        for i in 1...5 {
            let day = Calendar.current.date(byAdding: .day, value: i, to: today)!
            list.append(day)
        }
        
        return list
    }
    
    var dayAfterTomorrow: Date {
        return self.addingTimeInterval(86400 * 2)
    }
    
    var apmHourFormatString: String {
        return DateFormatterManager.apmHourFormatter.string(from: self)
    }
}
