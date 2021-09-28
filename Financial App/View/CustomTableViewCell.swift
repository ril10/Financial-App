//
//  CustomTableViewCell.swift
//  Financial App
//
//  Created by Sergey Luk on 25.09.21.
//

import UIKit
import CoreData

protocol CustomCellUpdate : AnyObject {
    func updateTableView()
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var changePrice: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    weak var delegate : CustomCellUpdate?
    
    var isFavorite : Bool?
    
    var favoriteList = [Favorite]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        
        if starButton.currentImage == UIImage(systemName: "star") {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.isFavorite = true
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.isFavorite = false
            
        }
        
        if isFavorite! {
            let favorite = Favorite(context: self.context)
            favorite.name = companyName.text
            favorite.symbol = symbol.text
            favorite.isFavorite = true
            favorite.currentPrice = currentPrice.text
            favoriteList.append(favorite)
            self.saveList()
            self.updateTableView()
        } else {
            self.deleteFromFavorite()
            self.updateTableView()
        }
        
        
    }
    
    func updateTableView() {
        delegate?.updateTableView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    //MARK: - Model Manupulation Methods
    func saveList() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "symbol== %@", symbol.text!)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func deleteFromFavorite() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "symbol== %@", symbol.text!)
        if let result = try? context.fetch(request) {
            for object in result {
                if object.symbol == symbol.text {
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}


