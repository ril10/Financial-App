//
//  FinhubDetail.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import CoreData

class TickDetail: UIViewController, Storyboarded {
    
    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    
    var favoriteList = [Favorite]()
    
    var listLots = [Lots]()
    
    var graphPoints = [Double]()
    
    var ticker : String = ""
    
    public static var tick = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var highPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    
    @IBOutlet weak var graph: GraphView!
    
    @IBOutlet weak var graphHighPrice: UILabel!
    @IBOutlet weak var graphLowPrice: UILabel!
    @IBOutlet weak var graphMiddlePrice: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configNavigator()
        webSocketTask.resume()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        let reason = "Closing connection".data(using: .utf8)
//        webSocketTask.cancel(with: .goingAway, reason: reason)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        TickDetail.tick = ticker
        
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        fm.loadDataCompany(ticker: self.ticker) { [self] company in
            DispatchQueue.main.async {
                name.text = company.name
                marketCap.text = String(company.marketCapitalization ?? 0.0)
                let noImage = URL(string: "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png")
                let url = URL(string: company.logo ?? "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png")
                downloadImage(from: (url) ?? (noImage!))
            }
        }
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(graphUpdate), userInfo: nil, repeats: true)
        
        
        
    }
    
    @objc func graphUpdate() {
        graph.setNeedsDisplay()
    }
    
    @objc func update() {
        self.fm.loadQuote(ticker: self.ticker) { [self] quote in
            DispatchQueue.main.async {
                
                if let lowPrice = quote.l {
                    self.lowPrice.text = String(lowPrice)
                    self.graph.bottomBorder = CGFloat(lowPrice)
                }
                
                if let openPrice = quote.o {
                    self.openPrice.text = String(openPrice)
                }
                
                if let highPrice = quote.h {
                    self.highPrice.text = String(highPrice)
                    self.graph.topBorder = CGFloat(highPrice)
                }

                graphHighPrice.text = highPrice.text
                graphMiddlePrice.text = openPrice.text
                graphLowPrice.text = lowPrice.text
            }
        }
        WebSocket.shared.receiveData { (data) in
            DispatchQueue.main.async {
                self.graph.graphPoints.append(data?.data[0].p ?? 0.0)
                self.currentPrice.text = String(data?.data[0].p ?? 0.0)
            }
            print(data?.data[0].p)
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
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoite)), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buyLots)), animated: true)
    }
    
    @objc func favoite() {

    }
    
    @objc func buyLots() {
        
        let currentTime = Date()
        
        var countTextField = UITextField()
        var priceLoat = UITextField()
        
        let alert = UIAlertController(title: "Save lot", message: "Here you can save lots that you bought", preferredStyle: .alert)
        
        let uuid = UUID().uuidString
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newLot = Lots(context: self.context)
            newLot.symbol = self.ticker
            newLot.costLots = priceLoat.text
            newLot.count = countTextField.text!
            newLot.date = currentTime
            newLot.id = uuid
            self.listLots.append(newLot)
            self.saveLoats()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Price of loat"
            priceLoat = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Count of lots"
            countTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manupulation Methods
    func saveLoats() {

        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }

    }
    
}
