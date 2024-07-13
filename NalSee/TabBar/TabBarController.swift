//
//  TabBarController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
        setTabBarItem()
    }
    
    func setTabBarAppearance(){
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = .blue
        appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func setTabBarItem(){
        let mapVC = UINavigationController(rootViewController: MapViewController())
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map"), tag: 0)

        let cityVC = UINavigationController(rootViewController: CitySearchViewController())
        cityVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        setViewControllers([mapVC, cityVC], animated: true)
    }
}
