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
    

    //MARK: - ConfigureCell
    
    
    
    //MARK: - LoadListSection
    func loadListInListSection () {

        let request : NSFetchRequest<List> = List.fetchRequest()

        do {
            list = try context.fetch(request)
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
    

