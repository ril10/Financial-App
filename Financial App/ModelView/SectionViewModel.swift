//
//  SectionViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import CoreData
import Dip

class SectionViewModel {
    
    var context : NSManagedObjectContext!
    var list : [List]!
    var favoriteList : [Favorite]!
    
    var tableViewReload : (() -> Void)?
    
    var symbol : String!
    var currentPrice : String!
    var companyName : String!
    
    var sectionModel = [SectionCellModel]() {
        didSet {
            tableViewReload?()
        }
    }
    //MARK: - ConfigureCell
    
    func fetchData(listData: [List]) {
        var resData = [SectionCellModel]()
        for l in listData {
            resData.append(createCellModel(res: l))
        }
        sectionModel = resData
    }
    
    func createCellModel(res: List) -> SectionCellModel {
        let name = res.name
        let list = res.list
        
        return SectionCellModel(sectionName: name!,list: list!)
    }
    
    func getResultCellModel(at indexPath: IndexPath) -> SectionCellModel {
        return sectionModel[indexPath.row]
    }
    
    func addToFavorite(addList: List?) {        
        let favorite = Favorite(context: self.context)
        favorite.companyName = self.companyName
        favorite.symbol = self.symbol
        favorite.isFavorite = true
        favorite.currentPrice = self.currentPrice
        favorite.parentList = addList
        favoriteList.append(favorite)
        saveListData()

    }
    //MARK: - LoadListSection
    func loadListInListSection () {

        let request : NSFetchRequest<List> = List.fetchRequest()

        do {
            list = try context.fetch(request)
            fetchData(listData: list)
        } catch {
            print("Error loading lists \(error)")
        }

        tableViewReload?()

    }
    
    func saveListData() {
                let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
                request.predicate = NSPredicate(format: "symbol== %@", symbol)
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context \(error)")
                    }
                }        
        tableViewReload?()
    }
    
}
    

