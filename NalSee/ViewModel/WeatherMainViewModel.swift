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
    
    var outputThreeOurResult: CObservable<[HourWeather]> = CObservable([])
    
    func getWeatherResult(){
        APIManager.shared.callForecast(lat: 37.572601, lon: 126.979289, completion: {
             result in
            switch result {
            case .success(let value):
                self.outputWeatherResult.value = value
                self.getThreeHourResult()
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
       
       
        outputThreeOurResult.value = list
        
    }
    
    
}
