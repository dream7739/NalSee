//
//  WeatherMainHeaderView.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import SnapKit

final class WeatherMainHeaderView: BaseView {
    
    private let cityLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    private let tempLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 60, weight: .medium)
        return label
    }()
    
    private let weatherLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(cityLabel)
        addSubview(tempLabel)
        addSubview(weatherLabel)
        addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(2)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(2)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(2)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }

    func configureData(_ data: CurrentWeatherResult){
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: data.main.temp)
        let celsiusStr = String(format: "%.f", celsius) + "°"
        
        let maxCelsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: data.main.temp_max)
        let maxCelsiusStr = String(format: "%.f", maxCelsius) + "°"
        
        let minCelsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: data.main.temp_min)
        let minCelsiusStr = String(format: "%.f", minCelsius) + "°"
        
        cityLabel.text = "\(data.name) city"
        tempLabel.text = celsiusStr
        weatherLabel.text = data.weather.first?.description
        descriptionLabel.text = "최고: \(maxCelsiusStr) | 최저: \(minCelsiusStr)"
    }
}
