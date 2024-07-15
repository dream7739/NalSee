//
//  WeekCastCollectionViewCell.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import Kingfisher
import SnapKit

final class WeekCastCollectionViewCell: BaseCollectionViewCell {
    let weekDayLabel = UILabel()
    let weatherImage = UIImageView()
    let lowTempLabel = UILabel()
    let highTempLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(weekDayLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(lowTempLabel)
        contentView.addSubview(highTempLabel)
    }
    
    override func configureLayout() {
        weekDayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.trailing.equalTo(lowTempLabel.snp.leading).offset(-10)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(30)
        }
        
        lowTempLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        highTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI() {
        weekDayLabel.textColor = .white
        weekDayLabel.font = .systemFont(ofSize: 18)
        
        lowTempLabel.textColor = .darkGray
        lowTempLabel.font = .systemFont(ofSize: 18)
        
        highTempLabel.textColor = .white
        highTempLabel.font = .systemFont(ofSize: 18)
        
    }
    
    func configureData(_ data: WeekWeather){
        weekDayLabel.text = data.weekDay
        
        let url = APIURL.weatherIcon + "/\(data.weather)@2x.png"
        guard let imageURL = URL(string: url) else { return }
        weatherImage.kf.setImage(with: imageURL)
        
        lowTempLabel.text = data.lowTemp
        highTempLabel.text = data.highTemp
    }
}
