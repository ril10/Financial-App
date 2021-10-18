//
//  CustomTableViewCell.swift
//  Financial App
//
//  Created by Sergey Luk on 25.09.21.
//

import UIKit
import RxSwift

protocol CustomCellUpdate : AnyObject {
    func updateTableView(symbol : String, companyName : String, currentPrice : String)
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    weak var delegate : CustomCellUpdate?
    
    var disposeBag = DisposeBag()
    var symbolName : String?
    
    var onDelete : ((String?) -> Void)?
    
    var isFavorite : Bool!
    
    
    var customCell : CustomCellModel? {
        didSet {
            symbol.text = customCell?.symbol
            companyName.text = customCell?.companyName
            currentPrice.text = customCell?.currentPrice
            isFavorite = customCell?.isFavorite
            symbolName = customCell?.symbol
        }
    }
    
    var resultCell : ResultSearchModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                symbol.text = resultCell?.symbol
                companyName.text = resultCell?.companyName
                resultCell?.requestService.requestQuote(symbol: symbol.text ?? "")
                    .subscribe(onNext: { quote in
                    DispatchQueue.main.async {
                        self.currentPrice.text = String(format: "%.2f", quote.c ?? 0.0)
                    }
                }).disposed(by: self.disposeBag)
            }
            
        }
    }
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        
        if starButton.currentImage == UIImage(systemName: "star") {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.isFavorite = true
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.isFavorite = false
        }
        
        if isFavorite! {
            updateTableView()
        } else {
            onDelete?(symbolName)

        }
 
    }
    
    
    func updateTableView() {
        delegate?.updateTableView(symbol: symbol.text!, companyName: companyName.text!, currentPrice: currentPrice.text!)
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


