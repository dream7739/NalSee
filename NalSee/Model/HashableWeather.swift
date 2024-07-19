//
//  HashableWeather.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit

struct HourWeather: Hashable, Identifiable {
    let id = UUID()
    let hour: String
    let weather: String
    let temp: String
}

struct WeekWeather: Hashable, Identifiable {
    let id = UUID()
    let weekDay: String
    let weather: String
    let lowTemp: String
    let highTemp: String
}

struct LocWeather: Hashable, Identifiable {
    let id = UUID()
    let lat: Double
    let lon: Double
}

struct DetailWeather: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}
