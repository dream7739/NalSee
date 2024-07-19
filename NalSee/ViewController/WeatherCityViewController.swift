//
//  WeatherCityViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import SnapKit

final class WeatherCityViewController: BaseViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    let viewModel = WeatherCityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        configureTableView()
        bind()
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

extension WeatherCityViewController {
    func bind(){
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.outputFilterCityResult.bind { value in
            self.tableView.reloadData()
        }
    }
}

extension WeatherCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        viewModel.inputSearchText.value = text
    }
}

extension WeatherCityViewController {
    private func configureSearch(){
        navigationItem.title = "City"
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a city."
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func configureTableView(){
        tableView.register(WeatherCityTableViewCell.self, forCellReuseIdentifier: WeatherCityTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WeatherCityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFilterCityResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCityTableViewCell.reuseIdentifier, for: indexPath) as? WeatherCityTableViewCell else { return UITableViewCell() }
        let data = viewModel.outputFilterCityResult.value[indexPath.row]
        cell.configureData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coord = viewModel.outputFilterCityResult.value[indexPath.row].coord
        viewModel.coordSender?(coord)
        navigationController?.popViewController(animated: true)
    }
}
