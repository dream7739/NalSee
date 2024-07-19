//
//  Double+.swift
//  NalSee
//
//  Created by 홍정민 on 7/19/24.
//

import Foundation

extension Double {
    var celsiusString: String {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: self)
        return String(format: "%.f", celsius) + "°"
    }
}
