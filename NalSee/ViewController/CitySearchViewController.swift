//
//  CitySearchViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import SnapKit

final class CitySearchViewController: BaseViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    let viewModel = CitySearchViewModel()
    
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

extension CitySearchViewController {
    func bind(){
        
        viewModel.inputViewDidLoadTrigger.value = ()
   
        viewModel.outputFilterCityResult.bind { value in
            self.tableView.reloadData()
        }
    }
}

extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        viewModel.inputSearchText.value = text
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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFilterCityResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        let data = viewModel.outputFilterCityResult.value[indexPath.row]
        cell.cityLabel.text = "# \(data.name)"
        cell.countryLabel.text = data.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coord = viewModel.outputFilterCityResult.value[indexPath.row].coord
        viewModel.coordSender?(coord)
        navigationController?.popViewController(animated: true)
        print(#function)
    }
}
