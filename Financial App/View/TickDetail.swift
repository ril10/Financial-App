//
//  FinhubDetail.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import Dip

class TickDetail: UIViewController, Storyboarded {
    
    var coordinator : MainCoordinator?
    
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
        //GraphData
        viewModel.graphData = { [self] graphC, graphO, graphT in
            DispatchQueue.main.async {
                graph.c.append(contentsOf: graphC)
                if graph.c.count > 0 {
                    graph.setNeedsDisplay()
                }
                graph.o.append(contentsOf: graphO)
                graph.t.append(contentsOf: graphT)
            }
        }
        viewModel.graphLabel = { [self] gHighPrice,gMiddlePrice,gLowPrice in
            DispatchQueue.main.async {
                graphHighPrice.text = String(format: "%.2f", gHighPrice)
                graphMiddlePrice.text = String(format: "%.2f", gMiddlePrice)
                graphLowPrice.text = String(format: "%.2f", gLowPrice)
            }
        }
        viewModel.graphTime = { [self] startTime,middleTime,endTime in
            DispatchQueue.main.async {
                startDate.text = startTime
                secondDate.text = middleTime
                endDate.text = endTime
            }
        }

        //Company
        viewModel.companyData = { [self] company, capital in
            DispatchQueue.main.async {
                name.text = company
                marketCap.text = capital
            }
        }
        //Logo
        viewModel.image = { [self] logotype in
            logo.image = UIImage(data: logotype)
        }
        //Label price
        viewModel.quot = { [self] c,o,l,h in
            DispatchQueue.main.async {
                currentPrice.text = c
                openPrice.text = o
                highPrice.text = h
                lowPrice.text = l
            }
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
        nav?.topItem?.title = viewModel.symbol
        nav?.tintColor = .darkGray
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buyLots)), animated: true)
    }
    
    
    @objc func buyLots() {
        
        let currentTime = Date()
        
        var countTextField = UITextField()
        var priceLoat = UITextField()
        
        let alert = UIAlertController(title: "Save lot", message: "Here you can add lots that you bought", preferredStyle: .alert)
        
        let uuid = UUID().uuidString
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newLot = Lots(context: self.viewModel.context)
            newLot.symbol = self.viewModel.symbol
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
