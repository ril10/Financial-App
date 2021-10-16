//
//  ListOfSectionCell.swift
//  Financial App
//
//  Created by administrator on 29.09.21.
//

import UIKit
import CoreData

protocol CloseListSection : AnyObject {
    func closeList()
}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var addToList : ((List?) ->Void)?
    
    weak var delegate : CloseListSection?
    
    var list : List?
    
    var listCellModel : SectionCellModel? {
        didSet {
            name.text = listCellModel?.sectionName
        }
    }
    
    @IBAction func addToList(_ sender: UIButton) {
                addToList?(list)
                closeList()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func closeList() {
        delegate?.closeList()
    }
    
}
