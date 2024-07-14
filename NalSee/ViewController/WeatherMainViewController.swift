//
//  WeatherMainViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import SnapKit

final class WeatherMainViewController: BaseViewController {

    private let headerView = WeatherMainHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func configureHierarchy() {
        view.addSubview(headerView)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
    }

    override func configureUI() {
        headerView.setData()
    }
    

}

