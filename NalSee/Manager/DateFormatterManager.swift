//
//  DateFormatterManager.swift
//  NalSee
//
//  Created by 홍정민 on 7/19/24.
//

import Foundation

struct DateFormatterManager {
    private init(){ }

    enum DateFormat: String {
        case apmHour = "a h시"
        case day = "EEEEE"
    }
        
    static let apmHourFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.apmHour.rawValue
        return formatter
    }()
    
    static let dayFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.day.rawValue
        return formatter
    }()
}
