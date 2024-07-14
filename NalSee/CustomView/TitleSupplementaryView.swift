//
//  TitleSupplementaryView.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import SnapKit

class TitleSupplementaryView: UICollectionReusableView {
    let calendarImage =  {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")!
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureHierarchy(){
        addSubview(calendarImage)
        addSubview(titleLabel)
    }
    
    func configureLayout(){
        calendarImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(calendarImage.snp.trailing).offset(2)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureUI(){
        backgroundColor = .black
    }
    
}
