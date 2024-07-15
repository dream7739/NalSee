//
//  DetailCollectionViewCell.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import SnapKit

final class DetailCollectionViewCell: BaseCollectionViewCell {
    let weatherImage = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(weatherImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        weatherImage.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherImage.snp.trailing).offset(4)
        }
      
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }

    }
    
    override func configureUI() {
        
        weatherImage.tintColor = .lightGray
        
        titleLabel.textColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 12)
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 23, weight: .medium)
        
    }
    
    func configureData(_ data: DetailWeather){
        weatherImage.image = UIImage(systemName: "wind")
        titleLabel.text = data.title
        descriptionLabel.text = data.detail
    }
}
