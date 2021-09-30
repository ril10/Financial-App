//
//  LotsCell.swift
//  Financial App
//
//  Created by administrator on 28.09.21.
//

import UIKit
import CoreData

protocol DeleteLoat : AnyObject {
    func deleteLoatFromList()
}

class LotsCell: UITableViewCell {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate : DeleteLoat?
    
    var loatID : String?
    
    @IBOutlet weak var symbolName: UILabel!
    @IBOutlet weak var loatCost: UILabel!
    @IBOutlet weak var countCost: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var valueDif: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func deleteLot(_ sender: UIButton) {
        deleteLoatFromCoreData()
        deleteLoatFromList()
    }
    
    func deleteLoatFromList() {
        delegate?.deleteLoatFromList()
    }
    
    func deleteLoatFromCoreData() {
        let request : NSFetchRequest<Lots> = Lots.fetchRequest()
        request.predicate = NSPredicate(format: "id== %@", loatID as! CVarArg)
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
    }

}
