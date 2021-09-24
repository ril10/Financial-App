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
    
    var graphPoints = [Double]()
    
    var ticker : String = ""
    
    public static var tick = ""
    
    
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
//                currentPrice.text = String(quote.c)
                lowPrice.text = String(quote.l)
                openPrice.text = String(quote.o)
                highPrice.text = String(quote.h)
                
                graph.topBorder = CGFloat(quote.h)
                graph.bottomBorder = CGFloat(quote.l)
                
                
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
        
    }
    
}
