//
//  ViewController.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import UIKit

class ViewController: UITableViewController,Storyboarded {

    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    
    var ticker = [SymbolCompany]()
    var searchTicker = [SymbolCompany]()
    
    let searchBar = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchBar.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchBar.isActive && !isSearchBarEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configNavigator()
        fm.loadSybmbolCompany { symbol in
            self.ticker = symbol
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        searchBar.searchResultsUpdater = self
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return searchTicker.count
        }
        return ticker.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let tickerSearch : SymbolCompany
        
        if isFiltering {
            tickerSearch = searchTicker[indexPath.row]
        } else {
            tickerSearch = ticker[indexPath.row]
        }
        
        cell.textLabel?.text = tickerSearch.symbol
        cell.detailTextLabel?.text = tickerSearch.description
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tickerSearch : SymbolCompany
        
        if isFiltering {
            tickerSearch = searchTicker[indexPath.row]
        } else {
            tickerSearch = ticker[indexPath.row]
        }
        
        coordinator?.finhubDetail(ticker: tickerSearch.symbol)
    }
    
    func configNavigator() {
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = false
        nav?.backItem?.title = ""
        nav?.topItem?.title = "Main"
        nav?.tintColor = .darkGray
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ViewController.searchController(_:)) ), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(ViewController.userAccount(_:))), animated: true)
        
    }
    
    @objc func userAccount(_ sender: UIButton?) {
        coordinator?.userAccount()
    }
    
    @objc func searchController(_ sender: UIButton?) {

            searchBar.obscuresBackgroundDuringPresentation = false
            searchBar.searchBar.placeholder = "Tickers,names"
            navigationItem.searchController = searchBar
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchTicker = ticker.filter { (searchTick: SymbolCompany) -> Bool in
            return searchTick.symbol.uppercased().contains(searchText.uppercased()) //|| searchTick.description.uppercased().contains(searchText.uppercased())
            
      }
      tableView.reloadData()
    }
        
}


