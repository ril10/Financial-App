//
//  ListOfSection.swift
//  Financial App
//
//  Created by administrator on 29.09.21.
//

import UIKit
import Dip

class ListOfSection: UITableViewController,Storyboarded,CloseListSection {

    var coordinator : MainCoordinator?
    
    var viewModel : SectionViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCells()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.tableViewReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.loadListInListSection()

    }

    func closeList() {
        coordinator?.start()
        coordinator?.dismiss()
    }
    
    //MARK: - ConfigNavBar
    func setupNavigator() {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = false
        nav?.backItem?.title = ""
        nav?.topItem?.title = "Add or remove from List"
        nav?.tintColor = .darkGray
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:))), animated: true)
    }
    
    @objc func close(_ sender: UIButton?) {
        coordinator?.start()
        coordinator?.dismiss()
    }
    
    // MARK: - Table view data source

    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "ListCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "ListCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Lists"
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.list.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        let cellVM = viewModel.getResultCellModel(at: indexPath)
        
        cell.listCellModel = cellVM
        cell.list = viewModel.list[indexPath.row]
        cell.addToList = viewModel.addToFavorite
        
        cell.delegate = self
        
        return cell
        
    }
    
}

//MARK: - StoryboardInstantiatable
extension ListOfSection : StoryboardInstantiatable {}
