//
//  UserAccountViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import RxSwift
import CoreData
import Dip

class UserAccountViewModel {
    
    var lots : [Lots]!
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var context : NSManagedObjectContext!
    var request : APIRequest!
    var quote : Observable<Quote>!
    var reloadTableView : (() -> Void)?
    
    
    var loatCellViewModel = [LotsCellModel]() {
        didSet {
            reloadTableView?()
        }
    }
    //MARK: - Configure Cell
    func fetchData(loat: [Lots]) {
        var loatsData = [LotsCellModel]()
        for lots in lots {
            loatsData.append(createCellModel(lots: lots))
        }
        loatCellViewModel = loatsData
    }
    
    
    func createCellModel(lots: Lots) -> LotsCellModel {
        let symbol = lots.symbol!
        let loatCost = lots.costLots!
        let countOfLoats = lots.count!
        let date = lots.date!
        let id = lots.id!
        
        quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: symbol))
        quote.subscribe(onNext: { quote in
            let buyValue = Double(loatCost)
            let currentValue = quote.c ?? 0.0
            let indexChange = ((currentValue - buyValue!) / buyValue!) * 100
            lots.valueDif = String(format: "%.2f", indexChange) + "%"
        }).disposed(by: self.disposeBag)

        let diffrence = lots.valueDif ?? "" + "%"

        return LotsCellModel(symbol: symbol, loatCost: loatCost, countOfLots: countOfLoats, date: date.dateFormatter(), diffrence: diffrence, id: id)
    }
    
    func getLoatsCellModel(at indexPath: IndexPath) -> LotsCellModel {
        return loatCellViewModel[indexPath.row]
    }
    //MARK: - Data Manipulations
    func loadLoatsList() {

        let request : NSFetchRequest<Lots> = Lots.fetchRequest()
        do {
            lots = try context.fetch(request)
            fetchData(loat: lots)
        } catch {
            print("Error loading Loats \(error)")
        }
        reloadTableView?()
    }
    
    func deleteLoatFromCoreData(loatID: String?) {
        let request : NSFetchRequest<Lots> = Lots.fetchRequest()
        request.predicate = NSPredicate(format: "id== %@", loatID!)
        if let result = try? context.fetch(request) {
            for object in result {
                if object.id == loatID {
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
        loadLoatsList()
    }
    
}
