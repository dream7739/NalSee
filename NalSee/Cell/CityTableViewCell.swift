//
//  CityTableViewCell.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import SnapKit

final class CityTableViewCell: BaseTableViewCell {
    let cityLabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    
    let countryLabel = {
        let label = UILabel()
        label.font = Font.tertiary
        label.textColor = .darkGray
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
    }
    
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(2)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        contentView.backgroundColor = .black
    }
    
}
