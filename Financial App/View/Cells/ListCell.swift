//
//  ListOfSectionCell.swift
//  Financial App
//
//  Created by administrator on 29.09.21.
//

import UIKit
import CoreData

protocol AddTolist : AnyObject {
    func addToList()
}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var isFavorite : Bool?
    
    weak var delegate : AddTolist?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var symbol : String!
    var companyName : String!
    var currentPrice : String!
    var changePrice : String!
    
    var favoriteList = [Favorite]()
    var list : List?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
    func addToList() {
        delegate?.addToList()
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        
        if starButton.currentImage == UIImage(systemName: "star") {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.isFavorite = true
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.isFavorite = false
        }
        
        if isFavorite! {
            let favorite = Favorite(context: self.context)
            favorite.name = companyName
            favorite.symbol = symbol
            favorite.isFavorite = true
            favorite.currentPrice = currentPrice
            favorite.parentList = self.list
            favoriteList.append(favorite)
            self.saveToList()
            addToList()
        }
        
    }
    
    func saveToList() {
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
    }
}
