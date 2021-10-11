//
//  ListOfSection.swift
//  Financial App
//
//  Created by administrator on 29.09.21.
//

import UIKit
import CoreData
import Dip

class ListOfSection: UITableViewController,Storyboarded,AddTolist,StoryboardInstantiatable {
    

    
    var context : NSManagedObjectContext!
    var list : [List]!

    var coordinator : MainCoordinator?
    
    var symbol : String?
    var companyName : String?
    var currentPrice : String?
    var changePrice : String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadListInListSection()
        
        registerTableViewCells()
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    func addToList() {
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
        saveListData()
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

        return list.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        cell.companyName = companyName
        cell.symbol = symbol
        cell.currentPrice = currentPrice
        cell.changePrice = changePrice
        
        cell.list = list[indexPath.row]
        
        cell.name.text = list[indexPath.row].name
        
        cell.delegate = self
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ListCell {
            cell.didSelect(indexPath: indexPath)
            
        }
    }
    //MARK: - LoadListSection
    func loadListInListSection () {

        let request : NSFetchRequest<List> = List.fetchRequest()

        do {
            list = try context.fetch(request)
        } catch {
            print("Error loading lists \(error)")
        }

        tableView.reloadData()

    }
    
    func saveListData() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
}
