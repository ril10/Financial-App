//
//  ViewControllerViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import CoreData
import RxSwift
import Dip

class ViewControllerViewModel {
    
    var list : [List]!
    var favoriteList : [Favorite]!
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var request : APIRequest!
    var quote : Observable<Quote>!
    var context : NSManagedObjectContext!
    
    var reloadTableView : (() -> Void)?
    
    var loadList : ListCellModel? {
        didSet {
            loadDataList()

        }
    }
    
    var favoriteViewModel = [CustomCellModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var listViewModel = [ListCellModel]() {
        didSet {
            reloadTableView?()
        }
    }
    //MARK: - ConfigureCell
    func fetchData(fav: [Favorite]) {
        var favData = [CustomCellModel]()
        for fav in favoriteList {
            favData.append(createCellModel(fav: fav))
        }
        favoriteViewModel = favData
    }
    
    func fetchList(list: [List]) {
        var listData = [ListCellModel]()
        for l in list {
            listData.append(createListCellModel(list: l))
        }
        listViewModel = listData
    }
    
    func createListCellModel(list: List) -> ListCellModel {
        let name = list.name
        let list = list.list
        self.loadList = ListCellModel(name: name!, list: list!)
        return ListCellModel(name: name!, list: list! )
    }
    
    func createCellModel(fav: Favorite) -> CustomCellModel {
        let symbol = fav.symbol!
        let companyName = fav.companyName!
        
        quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: symbol))
        quote.subscribe(onNext: { quote in
            fav.currentPrice = String(format: "%.2f", quote.c ?? 0.0)
        }).disposed(by: self.disposeBag)
        
        let currentPrice = fav.currentPrice
        
        let isFavorite = fav.isFavorite
        
        let parentList = fav.parentList

        return CustomCellModel(symbol: symbol, companyName: companyName, currentPrice: currentPrice!, isFavorite: isFavorite, parentList: parentList!)
    }
    
    func getFavoriteCellModel(at indexPath: IndexPath) -> CustomCellModel {
        return favoriteViewModel[indexPath.row]
    }
    
    
    
    //MARK: - Data Manipulations
    func saveList() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        reloadTableView?()
    }
    
    func loadAllList() {
        let request : NSFetchRequest<List> = List.fetchRequest()
        
        do {
            list = try context.fetch(request)
            fetchList(list: list)
            
        } catch {
            print(error)
        }
        reloadTableView?()
        
    }
    
    func loadDataList() {

        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        let predicate : NSPredicate? = nil
        request.predicate = NSPredicate(format: "parentList.name== %@", loadList?.name ?? "")

//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, additionalPredicate])
//        } else {
//            request.predicate = listPredicate
//        }

        do {
            favoriteList = try context.fetch(request)
            fetchData(fav: favoriteList)
        } catch {
            print("Error fetching data from context \(error)")
        }
        reloadTableView?()
    }
    
    
    func loadAllFavorites() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            favoriteList = try context.fetch(request)
            fetchData(fav: favoriteList)
        } catch {
            print("Error loading categories \(error)")
        }
        reloadTableView?()
        
    }
    
    
}