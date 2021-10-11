//
//  FinhubDetail.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import Dip

class TickDetail: UIViewController, Storyboarded,StoryboardInstantiatable {
    
    var coordinator : MainCoordinator?
    
    var lots : [Lots]!
    
    var ticker : String = ""
    
    var middle : Int? {
        graph.t.count / 2
    }
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    
    var context : NSManagedObjectContext!

    var request : APIRequest!
    
    var quote : Observable<Quote>!
    var stock : Observable<StockHandelData>!
    var company : Observable<FinhubCompany>!
    
    var from : Int?
    
    var to : Int?
    
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var highPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    
    @IBOutlet weak var graph: Graph!
    
    @IBOutlet weak var graphHighPrice: UILabel!
    @IBOutlet weak var graphLowPrice: UILabel!
    @IBOutlet weak var graphMiddlePrice: UILabel!
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var secondDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configNavigator()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stock = self.apiCalling.load(apiRequest: request.requestStockHandleData(symbol: ticker, from: from!, to: to!))
        stock.subscribe(onNext: { [self] stock in
            graph.c.append(contentsOf: stock.c)
            graph.o.append(contentsOf: stock.o)
            graph.t.append(contentsOf: stock.t)
            DispatchQueue.main.async {
                startDate.text = graphLabelDate(time: stock.t.first ?? 0)
                secondDate.text = graphLabelDate(time: stock.t[middle ?? 0])
                endDate.text = graphLabelDate(time: stock.t.last ?? 0)
                graphLabelValue()
                priceQuote()
                if graph.c.count > 0 {
                    graph.setNeedsDisplay()
                }
            }
        }).disposed(by: self.disposeBag)
        
        company = self.apiCalling.load(apiRequest: request.requestDataCompany(symbol: ticker))
        company.subscribe(onNext: { [self] company in
            DispatchQueue.main.async {
                name.text = company.name
                marketCap.text = String(company.marketCapitalization ?? 0.0)
                guard let noImage = URL(string: "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png") else { return }
                downloadImage(from: (URL(string: company.logo!) ?? noImage)!)
            }
        }).disposed(by: self.disposeBag)
        

    }
    
    func graphLabelValue() {
        let total = graph.c.reduce(0, +)
        let midVal = CGFloat(total) / CGFloat(graph.c.count)
        
        self.graphMiddlePrice.text = String(format: "%.2f", midVal)
        
        
        if let graphTopLabel = self.graph.c.max() {
            self.graphHighPrice.text = "\(graphTopLabel)"
        }
        
        if let graphLowLabel = self.graph.c.min() {
            self.graphLowPrice.text = "\(graphLowLabel)"
        }
    }
    
    func graphLabelDate(time: Int) -> String {
        
        let unixTime = time
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        let dateForm = formatter.string(from: date)
        return dateForm
        
    }
    
    func priceQuote() {
        quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: ticker))
        quote.subscribe(onNext:  { [self] quote in
            DispatchQueue.main.async {
                if let currentPrice = quote.c {
                    self.currentPrice.text = String(format: "%.2f", currentPrice)
                }
                
                if let lowPrice = quote.l {
                    self.lowPrice.text = String(format: "%.2f", lowPrice)
                }
                
                if let openPrice = quote.o {
                    self.openPrice.text = String(format: "%.2f", openPrice)
                }
                
                if let highPrice = quote.h {
                    self.highPrice.text = String(format: "%.2f", highPrice)
                }
            }
        }).disposed(by: self.disposeBag)

    }
    
    func downloadImage(from url: URL) {
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .subscribe(onNext: { (response, data) in
                DispatchQueue.main.async {
                    self.logo.image = UIImage(data: data)
                }
            }).disposed(by: self.disposeBag)
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
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buyLots)), animated: true)
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
            self.lots.append(newLot)
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
