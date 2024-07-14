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
    
    func setData(){
        cityLabel.text = "Jeju City"
        tempLabel.text = "5.9"
        weatherLabel.text = "Broken Clouds"
        descriptionLabel.text = "최고: 7.0 | 최저: -4.2"
    }
}
