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
    
    @IBOutlet weak var symbolName: UILabel!
    @IBOutlet weak var loatCost: UILabel!
    @IBOutlet weak var countCost: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteLot(_ sender: UIButton) {
        deleteLoat()
        deleteLoatFromList()
    }
    
    func deleteLoatFromList() {
        delegate?.deleteLoatFromList()
    }
    
    func deleteLoat() {
        let request : NSFetchRequest<Lots> = Lots.fetchRequest()
        request.predicate = NSPredicate(format: "id== %@", id.text!)
        if let result = try? context.fetch(request) {
            for object in result {
                if object.id == id.text {
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
