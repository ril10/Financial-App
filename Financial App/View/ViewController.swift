//
//  ViewController.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import UIKit
import CoreData
import RxSwift
import Dip

class ViewController: UITableViewController,Storyboarded,UpdateTableView {

    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var coordinator : MainCoordinator?
    var context : NSManagedObjectContext!

    
    var viewModel : ViewControllerViewModel!
    
    var time : Int? {
        Int(Date().timeIntervalSince1970) - 86400
    }

 
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",bundle: nil)
        self.tableView.register(textFieldCell,forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configNavigator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        self.registerTableViewCells()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.loadAllList()
        viewModel.loadDataList()
        viewModel.loadAllFavorites()



    }
    //MARK: - Setup SearchBar
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
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

        return viewModel.listViewModel.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return viewModel.listViewModel[section].name

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.listViewModel[section].list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell


        
        if viewModel.favoriteViewModel.count > 0 {
            
           let cellVM = viewModel.favoriteViewModel.filter { fav in
               return fav.parentList.name == viewModel.listViewModel[indexPath.section].name
           }[indexPath.row]

            cell.customCell = cellVM
            cell.onDelete = viewModel.deleteFromFavorite
            if cell.isFavorite == true {
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cellVM = viewModel.favoriteViewModel.filter { fav in
            return fav.parentList.name == viewModel.listViewModel[indexPath.section].name
        }[indexPath.row]
        coordinator?.finhubDetail(ticker: cellVM.symbol,from: time!, to: Int(Date().timeIntervalSince1970))
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
        
        nav?.isTranslucent = true
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
            
            let newList = List(context: self.viewModel.context)
            newList.name = listTextField.text
            self.viewModel.list.append(newList)
            self.viewModel.loadList = newList

            self.viewModel.saveList()

        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
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
    
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        coordinator?.searchController()
        searchBar.setShowsCancelButton(false, animated: true)
        return false
    }
    
}
//MARK: - StoryboardInstantiatable
extension ViewController : StoryboardInstantiatable {}


