//
//  CustomTableViewCell.swift
//  Financial App
//
//  Created by Sergey Luk on 25.09.21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var changePrice: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    private var isFavorite : Bool!
    
    var favoriteList = [Result]()
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        
        if starButton.currentImage == UIImage(systemName: "star") {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.isFavorite = true
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.isFavorite = false
        }
        
        if isFavorite {
            
            print("Is fav")
        } else {
            
            print("it's not")
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
