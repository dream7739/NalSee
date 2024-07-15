//
//  WeatherMainViewModel.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import Foundation

final class WeatherMainViewModel {
    var outputWeatherResult: CObservable<WeatherResult> = CObservable(
        WeatherResult(
            cod: "",
            list: [],
            city: CityInfo(
                id: 0,
                name: "",
                coord: CoordInfo(lat: 0, lon: 0)
            )
        )
    )
    
    var outputThreeHourResult: CObservable<[HourWeather]> = CObservable([])
    
    var outputFiveDayResult: CObservable<[WeekWeather]> = CObservable([])
    
    func getWeatherResult(){
        APIManager.shared.callForecast(lat: 37.572601, lon: 126.979289, completion: {
             result in
            switch result {
            case .success(let value):
                self.outputWeatherResult.value = value
                self.getThreeHourResult()
                self.getFiveDaysResult()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getThreeHourResult(){
        let currentDate = Date()
        let afterDate = Date(timeInterval: 86400 * 2, since: currentDate)

        let current = Int(currentDate.timeIntervalSince1970)
        let after = Int(afterDate.timeIntervalSince1970)
        
        let filteredList = outputWeatherResult.value.list.filter{
            $0.dt >= current && $0.dt <= after
        }
        
        var list: [HourWeather] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시"
        
        filteredList.forEach { value in
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(value.dt))
            let dateStr = dateFormatter.string(from: date)

            let weatherIcon = value.weather.first?.icon ?? ""
            
            let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: value.main.temp)
            let celsiusStr = String(format: "%.f", celsius) + "°"

            let hourWeather = HourWeather(hour: dateStr, weather: weatherIcon, temp: celsiusStr)
            
            list.append(hourWeather)
        }
       
        outputThreeHourResult.value = list
    }
    
    func getFiveDaysResult(){
        var list: [WeekWeather] = []
        
        let day1 = Calendar.current.startOfDay(for: Date())
        let day2 = Calendar.current.date(byAdding: .day, value: 1, to: day1)!
        let day3 = Calendar.current.date(byAdding: .day, value: 2, to: day1)!
        let day4 = Calendar.current.date(byAdding: .day, value: 3, to: day1)!
        let day5 = Calendar.current.date(byAdding: .day, value: 4, to: day1)!
        let day6 = Calendar.current.date(byAdding: .day, value: 5, to: day1)!

        let day = [day1, day2, day3, day4, day5, day6]
        
        for i in 0..<5 {
            let dayWeather = outputWeatherResult.value.list.filter {
                $0.dt >= Int(day[i].timeIntervalSince1970) && $0.dt < Int(day[i+1].timeIntervalSince1970)
            }
            
            let maxTemp = dayWeather.max {
                $0.main.temp_max > $1.main.temp_max
            }?.main.temp_max ?? 0
            
            let minTemp = dayWeather.min {
                $0.main.temp_min < $1.main.temp_min
            }?.main.temp_min ?? 0
            
            let maxCelsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: maxTemp)
            let maxCelsiusStr = String(format: "%.f", maxCelsius) + "°"
            
            let minCelsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: minTemp)
            let minCelsiusStr = String(format: "%.f", minCelsius) + "°"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEEE"
            let weekDayStr = dateFormatter.string(from: day[i])
            
            let weatherIcon = dayWeather.first?.weather.first?.icon ?? ""
            
            let weatherItem = WeekWeather(weekDay: weekDayStr, weather: weatherIcon, lowTemp: minCelsiusStr, highTemp: maxCelsiusStr)
            
            list.append(weatherItem)
            
        }
        outputFiveDayResult.value = list

    }
    
}
