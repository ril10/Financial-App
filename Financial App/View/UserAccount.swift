//
//  UserAccount.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import CoreData

class UserAccount : UITableViewController, Storyboarded,DeleteLoat {

    var coordinator : MainCoordinator?
    var myLots = [Lots]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadLoatsList()
        setupNavigator()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.registerTableViewCells()
    }
    
    //MARK: -TableRow
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "LotsCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "LotsCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotsCell", for: indexPath) as! LotsCell
        
        let time = myLots[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formatedDate = formatter.string(from: time ?? Date())
        
        
        cell.date.sizeToFit()
        
        cell.symbolName.text = myLots[indexPath.row].symbol
        cell.loatCost.text = myLots[indexPath.row].costLots
        cell.countCost.text = myLots[indexPath.row].count
        cell.date.text = formatedDate
        cell.id.text = myLots[indexPath.row].id
        
        
        cell.delegate = self
        
        return cell
        
    }
    
    
    func deleteLoatFromList() {
        tableView.reloadData()
    }
    
    func loadLoatsList() {

        let request : NSFetchRequest<Lots> = Lots.fetchRequest()

        do{
            myLots = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }

        tableView.reloadData()

    }
    

    
    
    
    //MARK: -NavBarSetup
    func setupNavigator() {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = false
        nav?.backItem?.title = ""
        nav?.topItem?.title = "My loats"
        nav?.tintColor = .darkGray
    }
    
}
