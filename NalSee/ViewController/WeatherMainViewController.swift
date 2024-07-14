//
//  WeatherMainViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import SnapKit

final class WeatherMainViewController: BaseViewController {
    
    static let tempSectionHeader = "tempSectionHeader"
    
    let headerView = WeatherMainHeaderView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    struct HourWeather: Hashable {
        let hour: String
        let weather: UIImage
        let temp: String
    }
    
    
    struct WeekWeather: Hashable {
        let weekDay: String
        let weather: UIImage
        let lowTemp: String
        let highTemp: String
    }
    
    typealias Item = AnyHashable
    
    let dummyWeather: [HourWeather] = [
        HourWeather(hour: "11", weather: UIImage(systemName: "heart.fill")!, temp: "14"),
        HourWeather(hour: "13", weather: UIImage(systemName: "heart.fill")!, temp: "16"),
        HourWeather(hour: "15", weather: UIImage(systemName: "heart.fill")!, temp: "18"),
        HourWeather(hour: "17", weather: UIImage(systemName: "heart.fill")!, temp: "20"),
        HourWeather(hour: "19", weather: UIImage(systemName: "heart.fill")!, temp: "22")
    ]
    
    
    let dummyWeekWeather: [WeekWeather] = [
        WeekWeather(weekDay: "오늘", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
        WeekWeather(weekDay: "목", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -3", highTemp: "최고 10"),
        WeekWeather(weekDay: "금", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -4", highTemp: "최고 11"),
        WeekWeather(weekDay: "토", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -5", highTemp: "최고 12"),
        WeekWeather(weekDay: "일", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 13"),
        WeekWeather(weekDay: "월", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
        WeekWeather(weekDay: "화", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
        WeekWeather(weekDay: "수", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
        WeekWeather(weekDay: "목", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
        WeekWeather(weekDay: "금", weather: UIImage(systemName: "heart.fill")!, lowTemp: "최저 -2", highTemp: "최고 9"),
    ]
    
    
    enum Section: String, CaseIterable {
        case hour = "3시간 간격의 일기예보"
        case week = "5일간의 일기예보"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configureHierarchy() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI() {
        headerView.setData()
        configureDataSource()
        collectionView.backgroundColor = .black
    }
    
    
}

extension WeatherMainViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ section, env in
            switch Section.allCases[section] {
            case .hour:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous //좌우 스크롤이 가능하게 함
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
                
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: WeatherMainViewController.tempSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .week:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(440))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
                
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: WeatherMainViewController.tempSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config

        return layout
    }
    
    func configureDataSource(){
        let hourCellRegisteration = UICollectionView.CellRegistration<HourCastCollectionViewCell, HourWeather>.init { cell, indexPath, itemIdentifier in
            cell.hourLabel.text = itemIdentifier.hour
            cell.weatherImage.image = itemIdentifier.weather
            cell.tempLabel.text = itemIdentifier.temp
        }
        
        let weekCellRegisteration = UICollectionView.CellRegistration<WeekCastCollectionViewCell, WeekWeather>.init { cell, indexPath, itemIdentifier in
            cell.weekDayLabel.text = itemIdentifier.weekDay
            cell.weatherImage.image = itemIdentifier.weather
            cell.lowTempLabel.text = itemIdentifier.lowTemp
            cell.highTempLabel.text = itemIdentifier.highTemp
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: WeatherMainViewController.tempSectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = Section.allCases[indexPath.section].rawValue
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch Section.allCases[indexPath.section]{
            case .hour:
                guard let item = itemIdentifier as? WeatherMainViewController.HourWeather  else { return UICollectionViewCell() }
                let cell = collectionView.dequeueConfiguredReusableCell(using: hourCellRegisteration, for: indexPath, item: item)
                return cell
            case .week:
                guard let item = itemIdentifier as? WeatherMainViewController.WeekWeather  else { return UICollectionViewCell() }
                let cell = collectionView.dequeueConfiguredReusableCell(using: weekCellRegisteration, for: indexPath, item: item)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.hour, .week])
        snapshot.appendItems(dummyWeather, toSection: .hour)
        snapshot.appendItems(dummyWeekWeather, toSection: .week)
        
        dataSource.apply(snapshot)
        
    }
}
