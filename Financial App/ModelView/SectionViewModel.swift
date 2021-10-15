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
    
    var tableViewReload : (() -> Void)?
    
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
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableViewReload?()
    }
    
}
    

