//
//  LotsCell.swift
//  Financial App
//
//  Created by administrator on 28.09.21.
//

import UIKit

class LotsCell: UITableViewCell {
    
    var loatID : String?
    
    var onDelete : ((String?) -> Void)?
    
    @IBOutlet weak var symbolName: UILabel!
    @IBOutlet weak var loatCost: UILabel!
    @IBOutlet weak var countCost: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var valueDif: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var lotsCell : LotsCellModel? {
        didSet {
            symbolName.text = lotsCell?.symbol
            loatCost.text = lotsCell?.loatCost
            countCost.text = lotsCell?.countOfLots
            date.text = lotsCell?.date
            loatID = lotsCell?.id
            if lotsCell?.diffrence.contains("-") == false {
                valueDif.textColor = UIColor.green
            } else {
                valueDif.textColor = UIColor.red
            }
            
            valueDif.text = lotsCell?.diffrence
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func deleteLot(_ sender: UIButton) {
        onDelete?(loatID)
    }
    
    

}
