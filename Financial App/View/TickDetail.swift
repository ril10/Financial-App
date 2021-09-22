//
//  FinhubDetail.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit

class TickDetail: UIViewController, Storyboarded {
    
    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    var ticker : String?
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var highPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigator()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        fm.loadDataCompany(ticker: ticker ?? "") { [self] company in
            DispatchQueue.main.async {
                name.text = company.name
                marketCap.text = String(company.marketCapitalization ?? 0.0)
                let noImage = URL(string: "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png")
                let url = URL(string: company.logo ?? "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png")
                downloadImage(from: (url) ?? (noImage!))
            }
        }

        
    }
    
    @objc func update() {
        self.fm.loadQuote(ticker: self.ticker ?? "") { [self] quote in
         DispatchQueue.main.async {
             currentPrice.text = String(quote.c)
             lowPrice.text = String(quote.l)
             openPrice.text = String(quote.o)
             highPrice.text = String(quote.h)
            print("updated")
         }
     }
    }

    
    func downloadImage(from url: URL) {

        fm.getDataImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() { [weak self] in
                self?.logo.image = UIImage(data: data)
            }
        }
    }
    
    func configNavigator() {
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = false
        nav?.backItem?.title = ""
        nav?.topItem?.title = ticker
        nav?.tintColor = .darkGray
        
    }


}
