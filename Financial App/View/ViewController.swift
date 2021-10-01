//
//  ViewController.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import UIKit
import CoreData

class ViewController: UITableViewController,Storyboarded,UpdateTableView {

    
    private let searchController = UISearchController(searchResultsController: nil)
    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var list = [List]()
    
    var loadList : List? {
        didSet {
            loadDataList()
        }
    }
    
    var favoriteList = [Favorite]()
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",bundle: nil)
        self.tableView.register(textFieldCell,forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadListSection()
        
        configNavigator()
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
    //MARK: - Setup SearchBar
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Tick and name"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    //MARK: - TableView
    func tableViewReload() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return list[section].name

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
                
        fm.loadQuote(ticker: favoriteList[indexPath.row].symbol ?? "No Symbol") { quote in
            DispatchQueue.main.async {
                if let currentPrice = quote.c {
                    cell.currentPrice.text = String(currentPrice)
                }
            }
        }
        
        cell.symbol.text = favoriteList[indexPath.row].symbol
        cell.companyName.text = favoriteList[indexPath.row].companyName
        
        
        if favoriteList[indexPath.row].isFavorite {
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        } else {
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            saveList()
        }
        
        
        cell.mainDelegate = self

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.finhubDetail(ticker: favoriteList[indexPath.row].symbol!)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Config NavBar
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
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(ViewController.userAccount(_:))), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createList(_:))), animated: true)

    }
    
    @objc func createList(_ sender: UIButton?) {
        
        var listTextField = UITextField()
        
        let alert = UIAlertController(title: "Create List", message: "Create new list for your tickers", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add list", style: .default) { (action) in
            
            let newList = List(context: self.context)
            newList.name = listTextField.text
            self.list.append(newList)
            self.loadList = newList
            self.saveList()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type name of your list"
            listTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func userAccount(_ sender: UIButton?) {
        coordinator?.userAccount()
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveList() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadDataList() {

        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let predicate : NSPredicate? = nil

        let listPredicate = NSPredicate(format: "parentList.name MATCHES %@", loadList!.name!)
        print(listPredicate)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, additionalPredicate])
        } else {
            request.predicate = listPredicate
        }

        do {
            favoriteList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()

    }
    
    func loadAllFavorites() {
        
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            favoriteList = try context.fetch(request)
            
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadListSection () {
        
        let request : NSFetchRequest<List> = List.fetchRequest()
        
        do {
            list = try context.fetch(request)
            
        } catch {
            print("Error loading lists \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        coordinator?.searchController()
        searchBar.setShowsCancelButton(false, animated: true)
        return false
    }
    
}


