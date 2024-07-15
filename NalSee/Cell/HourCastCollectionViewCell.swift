//
//  HourCastCollectionViewCell.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import Kingfisher
import SnapKit

final class HourCastCollectionViewCell: BaseCollectionViewCell {
    let hourLabel = UILabel()
    let weatherImage = UIImageView()
    let tempLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(hourLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(tempLabel)
    }
    
    override func configureLayout() {
        hourLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(hourLabel.snp.bottom).offset(4)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(50)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(4)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        contentView.backgroundColor = .black
        hourLabel.textColor = .white
        tempLabel.textColor = .white
    }
    
    func configureData(_ data: HourWeather){
        hourLabel.text = data.hour
        
        let url = APIURL.weatherIcon + "/\(data.weather)@2x.png"
        guard let imageURL = URL(string: url) else { return }
        weatherImage.kf.setImage(with: imageURL)
        
        tempLabel.text = data.temp
    }
}
