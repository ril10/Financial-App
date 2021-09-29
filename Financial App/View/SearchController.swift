//
//  SearchController.swift
//  Financial App
//
//  Created by administrator on 27.09.21.
//

import UIKit
import CoreData

class SearchController: UITableViewController,Storyboarded,CustomCellUpdate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let searchController = UISearchController(searchResultsController: nil)
    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    
    var searchResult = [Result]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        setupSearchBar()
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        

    }
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Tick and name"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        fm.loadQuote(ticker: searchResult[indexPath.row].symbol) { quote in
            DispatchQueue.main.async {
                cell.currentPrice.text = String(quote.c)
            }
    }
        
        cell.symbol.text = searchResult[indexPath.row].symbol
        cell.companyName.text = searchResult[indexPath.row].description
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.finhubDetail(ticker: searchResult[indexPath.row].symbol)
        coordinator?.dismiss()
    }
    
    func updateTableView(symbol : String, companyName : String, currentPrice : String, changePrice : String) {
        coordinator?.listController(symbol: symbol, companyName: companyName, currentPrice: currentPrice, changePrice: changePrice)
        coordinator?.dismiss()
    }
    //MARK: - Model Manupulation Methods
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

}

extension SearchController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult.removeAll()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        searchResults(text: textToSearch)
    }
    
    func searchResults(text: String) {
        DispatchQueue.main.async {
            self.fm.searchFinhub(search: text) { result in
                self.searchResult = result.result
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResult.removeAll()
        coordinator?.dismiss()
        saveItems()
    }
    
    
}
