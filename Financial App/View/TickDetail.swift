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

class TickDetail: UIViewController, Storyboarded {
    
    var coordinator : MainCoordinator?
    
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
    
    var viewModel : TickDetailViewModel!
    
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
        viewModel.reloadView = { [weak self] in
            DispatchQueue.main.async {
                self?.view.setNeedsDisplay()
            }
        }
        viewModel.priceQuote(symbol: ticker)
        viewModel.companyData(symbol: ticker)
        viewModel.requestStockHandleData(symbol: ticker, from: from!, to: to!)
        
        viewModel.gc = { [self] graphC in
            DispatchQueue.main.async {
                graph.c.append(contentsOf: graphC)
                if graph.c.count > 0 {
                    graph.setNeedsDisplay()
                }
            }
        }
        viewModel.go = { [self] graphO in
            DispatchQueue.main.async {
                graph.o.append(contentsOf: graphO)
            }
        }
        viewModel.gt = { [self] graphT in
            DispatchQueue.main.async {
                graph.t.append(contentsOf: graphT)
            }
        }
        viewModel.gHP = { [self] gHighPrice in
            DispatchQueue.main.async {
                graphHighPrice.text = String(format: "%.2f", gHighPrice)
            }
        }
        viewModel.mDP = { [self] gMiddlePrice in
            DispatchQueue.main.async {
                graphMiddlePrice.text = String(format: "%.2f", gMiddlePrice)
            }
        }
        viewModel.lP = { [self] gLowPrice in
            DispatchQueue.main.async {
                graphLowPrice.text = String(format: "%.2f", gLowPrice)
            }
        }
        viewModel.startT = { [self] startTime in
            DispatchQueue.main.async {
                startDate.text = startTime
            }
        }
        viewModel.middleT = { [self] middleTime in
            DispatchQueue.main.async {
                secondDate.text = middleTime
            }
        }
        viewModel.endT = { [self] endTime in
            DispatchQueue.main.async {
                endDate.text = endTime
            }
        }
        
        stock = self.apiCalling.load(apiRequest: request.requestStockHandleData(symbol: ticker, from: from!, to: to!))
        stock.subscribe(onNext: { [self] stock in
            DispatchQueue.main.async {
                startDate.text = stock.t.first?.graphLabelDate()
                secondDate.text = stock.t[middle ?? 0].graphLabelDate()
                endDate.text = stock.t.last?.graphLabelDate()
                graphLabelValue()
                if graph.c.count > 0 {
                    graph.setNeedsDisplay()
                }
            }
        }).disposed(by: self.disposeBag)
        //Company
        viewModel.companyName = { [self] company in
            DispatchQueue.main.async {
                name.text = company
            }
        }
        viewModel.market = { [self] capital in
            DispatchQueue.main.async {
                marketCap.text = capital
            }
        }
        viewModel.image = { [self] logotype in
            logo.image = UIImage(data: logotype)
        }
        //Label price
        viewModel.c = { [self] current in
            DispatchQueue.main.async {
                currentPrice.text = current
            }
        }
        viewModel.o = { [self] open in
            DispatchQueue.main.async {
                openPrice.text = open
            }
        }
        viewModel.h = { [self] high in
            DispatchQueue.main.async {
                highPrice.text = high
            }
        }
        viewModel.l = { [self] low in
            DispatchQueue.main.async {
                lowPrice.text = low
            }
        }
        

    }
    
    func graphLabelValue() {
        let total = graph.c.reduce(0, +)
        let midVal = CGFloat(total) / CGFloat(graph.c.count)
        
        self.graphMiddlePrice.text = String(format: "%.2f", midVal)
        
        
        if let graphTopLabel = self.graph.c.max() {
            self.graphHighPrice.text = String(format: "%.2f", graphTopLabel)
        }
        
        if let graphLowLabel = self.graph.c.min() {
            self.graphLowPrice.text = String(format: "%.2f", graphLowLabel)
        }
    }
    
    func configNavigator() {
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = true
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
            self.viewModel.lots.append(newLot)
            self.viewModel.saveLoats()
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

    
}
//MARK: - StoryboardInstantiatable
extension TickDetail : StoryboardInstantiatable {}
