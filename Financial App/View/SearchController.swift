//
//  SearchController.swift
//  Financial App
//
//  Created by administrator on 27.09.21.
//

import UIKit
import CoreData
import RxSwift
import Dip

class SearchController: UITableViewController,Storyboarded,CustomCellUpdate {
    
    var viewModel : SearchControllerViewModel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var coordinator : MainCoordinator?
    
    var time : Int? {
        Int(Date().timeIntervalSince1970) - 86400
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.registerTableViewCells()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        setupSearchBar()
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        

    }
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Tick and name"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.resultModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let cellVm = viewModel.getResultCellModel(at: indexPath)
        cell.resultCell = cellVm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVm = viewModel.getResultCellModel(at: indexPath)
        
        coordinator?.finhubDetail(ticker: cellVm.symbol,from: time!,to: Int(Date().timeIntervalSince1970))
        coordinator?.dismiss()
    }
    
    func updateTableView(symbol : String, companyName : String, currentPrice : String) {
        coordinator?.listController(symbol: symbol, companyName: companyName, currentPrice: currentPrice)
        coordinator?.dismiss()
    }

}
//MARK: - SearchControllerDelegate
extension SearchController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.resultModel.removeAll()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        viewModel.searchResults(text: textToSearch)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resultModel.removeAll()
        coordinator?.dismiss()
    }
    
    
}
//MARK: - StoryboardInstantiatable
extension SearchController : StoryboardInstantiatable {}
