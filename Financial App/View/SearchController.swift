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

class SearchController: UITableViewController,Storyboarded,CustomCellUpdate,StoryboardInstantiatable {

    var context : NSManagedObjectContext!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var coordinator : MainCoordinator?
    
    var searchResult = [Result]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var request : APIRequest!
    
    var quote : Observable<Quote>!
    var search : Observable<ResultSearch>!
    
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
        let dataCell = searchResult[indexPath.row]
        
        quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: dataCell.symbol))
        quote.subscribe(onNext: { quote in
            DispatchQueue.main.async {
                if let currentPrice = quote.c {
                    cell.currentPrice.text = String(format: "%.2f", currentPrice)
                }
            }
        }).disposed(by: self.disposeBag)
        
        cell.symbol.text = dataCell.symbol
        cell.companyName.text = dataCell.description
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataCell = searchResult[indexPath.row]
        
        coordinator?.finhubDetail(ticker: dataCell.symbol,from: time!,to: Int(Date().timeIntervalSince1970))
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
//MARK: - SearchControllerDelegate
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
            self.search = self.apiCalling.load(apiRequest: self.request.requestSearch(search: text))
            self.search?.subscribe(onNext:  { result in
                if let searchResult = result.result {
                    self.searchResult = searchResult
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResult.removeAll()
        coordinator?.dismiss()
        saveItems()
    }
    
    
}
