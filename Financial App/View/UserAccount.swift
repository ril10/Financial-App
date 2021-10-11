//
//  UserAccount.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import CoreData
import RxSwift
import Dip

class UserAccount : UITableViewController, Storyboarded,DeleteLoat,StoryboardInstantiatable {

    var coordinator : MainCoordinator?
    
    var lots : [Lots]!
    
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    
    var context : NSManagedObjectContext!
    
    var request : APIRequest!
    
    var quote : Observable<Quote>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLoatsList()
        setupNavigator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.registerTableViewCells()
 
    }
    
    //MARK: - TableRow
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "LotsCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "LotsCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotsCell", for: indexPath) as! LotsCell
        let dataCell = lots[indexPath.row]
        
        quote = apiCalling.load(apiRequest: request.requestQuote(symbol: dataCell.symbol ?? ""))
        quote.subscribe(onNext: { quote in
            let buyValue = Double(dataCell.costLots!)
            let currentValue = quote.c ?? 0.0
            let indexChange = ((currentValue - buyValue!) / buyValue!) * 100
            dataCell.valueDif = String(format: "%.2f", indexChange) + "%"
        }).disposed(by: self.disposeBag)


        cell.symbolName.text = dataCell.symbol
        cell.loatCost.text = dataCell.costLots
        cell.countCost.text = dataCell.count
        cell.date.text = dateFormatter(date: dataCell.date)
        cell.loatID = dataCell.id
        cell.valueDif.text = dataCell.valueDif ?? "" + "%"
        
        let colorChangePrice = dataCell.valueDif?.contains("-")
        if colorChangePrice == false {
                cell.valueDif.textColor = UIColor.green
            } else {
                cell.valueDif.textColor = UIColor.red
            }
        
        
        if cell.isDelete {
            lots.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            saveList()
        }
        
        cell.delegate = self
        
        return cell
        
    }
    
    func dateFormatter(date : Date?) -> String {
        let time = date
        let formmater = DateFormatter()
        formmater.dateFormat = "MM-dd-yyyy HH:mm"
        let formatedDate = formmater.string(from: time ?? Date())
     
        return formatedDate
    }
    //MARK: - Data Manipulations
    func deleteLoatFromList() {
        tableView.reloadData()
    }
    
    func saveList() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadLoatsList() {

        let request : NSFetchRequest<Lots> = Lots.fetchRequest()

        do {
            lots = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    //MARK: - NavBarSetup
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
