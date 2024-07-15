//
//  CitySearchViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CitySearchViewController: BaseViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        configureTableView()
        bind(CitySearchViewModel())
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationController?.navigationBar.isHidden = false
    }
    
}

extension CitySearchViewController {
    func bind(_ viewModel: CitySearchViewModel){
        viewModel.getCellData().bind(to: tableView.rx.items){
            (tableView: UITableView, index: Int, element: City) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier) as? CityTableViewCell
            else { fatalError() }
            cell.cityLabel.text = "# " + element.name
            cell.countryLabel.text = element.country
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind{ [weak self] indexPath in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}

extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
}

extension CitySearchViewController {
    private func configureSearch(){
        navigationItem.title = "City"
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a city."
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func configureTableView(){
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .black
    }
}

