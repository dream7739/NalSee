//
//  WeatherMainViewModel.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import Foundation

final class WeatherMainViewModel {
    var inputCoord: CObservable<Coord?> = CObservable(nil)
    
    var outputUpdateTrigger: CObservable<Void?> = CObservable(nil)
    var outputThreeHourResult: CObservable<[HourWeather]> = CObservable([])
    var outputFiveDayResult: CObservable<[WeekWeather]> = CObservable([])
    var outputLocationResult: CObservable<[LocWeather]> = CObservable([])
    var outputDetailResult: CObservable<[DetailWeather]> = CObservable([])
    
    var weatherReuslt: WeatherResult?
    var currentWeatherResult: CurrentWeatherResult?
    
    init(){
        transform()
    }
    
    private func transform(){
        inputCoord.bind { value in
            self.callWeatherAPI()
        }
    }
}

extension WeatherMainViewModel {
    //시간별, 현재 날씨를 조회
    private func callWeatherAPI(){
        guard let coord = inputCoord.value else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group){
            APIManager.shared.callForecast(coord,  completion: {
                 result in
                switch result {
                case .success(let value):
                    self.weatherReuslt = value
                case .failure(let error):
                    print(error)
                }
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            APIManager.shared.callCurrentForecast(coord, completion: {
                 result in
                switch result {
                case .success(let value):
                    self.currentWeatherResult = value
                case .failure(let error):
                    print(error)
                }
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            self.outputUpdateTrigger.value = ()
            
            self.getThreeHourResult()
            self.getFiveDaysResult()
            self.getDetailResult()
            
            self.outputLocationResult.value = [LocWeather(
                lat: coord.lat,
                lon: coord.lon
            )]
        }
    }
    
    //3시간 간격의 일기예보
    private func getThreeHourResult(){
        guard let weatherReuslt = weatherReuslt else { return }
        var list: [HourWeather] = []

        let date = Date()
        let current = date.toTimeInterval
        let after = date.dayAfterTomorrow.toTimeInterval
        
        let filterList = weatherReuslt.list.filter{
            $0.dt >= current && $0.dt <= after
        }
        
        filterList.forEach { value in
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(value.dt))
            let dateString = date.apmHourFormatString
            let weatherIcon = value.weather.first?.icon ?? ""
            let celsiusString = value.main.temp.celsiusString
            let hourWeather = HourWeather(
                hour: dateString,
                weather: weatherIcon,
                temp: celsiusString
            )
            list.append(hourWeather)
        }
       
        //필터링 된 데이터를 output에 설정
        outputThreeHourResult.value = list
    }
    
    //5일간의 일기예보
    private func getFiveDaysResult(){
        guard let weatherReuslt = weatherReuslt else { return }

        var list: [WeekWeather] = []
        
        let sixWeekDayList = Date().sixWeekDays
        
        for i in 0..<sixWeekDayList.count - 1 {
            
            let filterList = weatherReuslt.list.filter {
                $0.dt >= sixWeekDayList[i].toTimeInterval &&
                $0.dt < sixWeekDayList[i+1].toTimeInterval
            }
            
            let weekDayString = DateFormatterManager.dayFormatter.string(from: sixWeekDayList[i])
            let weatherIcon = filterList.first?.weather.first?.icon ?? ""
            
            let minTemp = filterList.min {
                $0.main.temp_min < $1.main.temp_min
            }?.main.temp_min ?? 0
            
            let maxTemp = filterList.max {
                $0.main.temp_max > $1.main.temp_max
            }?.main.temp_max ?? 0
      
            let minCelsiusString = minTemp.celsiusString
            let maxCelsiusString = maxTemp.celsiusString
            
            let weekWeather = WeekWeather(
                weekDay: weekDayString,
                weather: weatherIcon,
                lowTemp: minCelsiusString,
                highTemp: maxCelsiusString
            )
            
            list.append(weekWeather)
        }
        
        outputFiveDayResult.value = list
    }
 
    //현재 일기예보 - 바람속도, 구름, 기압, 습도
    func getDetailResult(){
        guard let currentWeatherResult = currentWeatherResult else { return }

        var list: [DetailWeather] = []
        
        let windSpeed = "\(currentWeatherResult.wind.speed)m/s"
        let cloud = "\(currentWeatherResult.clouds.all)%"
        let pressure = "\(currentWeatherResult.main.pressure)hps"
        let humidity = "\(currentWeatherResult.main.humidity)%"
        
        let titleList = ["바람속도", "구름", "기압", "습도"]
        let detailList: [String] = [windSpeed, cloud, pressure, humidity]
        
        for i in 0..<titleList.count {
            list.append(
                DetailWeather(title: titleList[i], detail: detailList[i])
            )
        }
        
        outputDetailResult.value = list
    }
}
