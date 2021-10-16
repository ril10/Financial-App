//
//  UserAccount.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import Dip

class UserAccount : UITableViewController, Storyboarded {

    var coordinator : MainCoordinator?
    
    var viewModel : UserAccountViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigator()
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
        viewModel.loadLoatsList()

    }
    
    //MARK: - TableRow
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "LotsCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "LotsCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.loatCellViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotsCell", for: indexPath) as! LotsCell
        let cellVM = viewModel.getLoatsCellModel(at: indexPath)
        cell.lotsCell = cellVM
        cell.onDelete = viewModel.deleteLoatFromCoreData
        
        return cell
        
    }

    
    //MARK: - NavBarSetup
    func setupNavigator() {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = true
        nav?.backItem?.title = ""
        nav?.topItem?.title = "My loats"
        nav?.tintColor = .darkGray
    }
    
}
//MARK: - StoryboardInstantiatable
extension UserAccount : StoryboardInstantiatable {}
