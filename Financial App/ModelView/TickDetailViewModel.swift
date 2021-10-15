//
//  TickDetailViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import Dip
import RxSwift
import CoreData


class TickDetailViewModel {
    
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var lots : [Lots]!
    var request : APIRequest!
    var quote : Observable<Quote>!
    var stock : Observable<StockHandelData>!
    var company : Observable<FinhubCompany>!
    var context : NSManagedObjectContext!
    
    var reloadView : (() -> Void)?
    //Company
    var companyName : ((String) -> Void)?
    var market : ((String) -> Void)?
    var image : ((Data) -> Void)?
    //Quote
    var c : ((String) -> Void)?
    var o : ((String) -> Void)?
    var l : ((String) -> Void)?
    var h : ((String) -> Void)?
    //Stock
    var gc : (([Double]) -> Void)?
    var go : (([Double]) -> Void)?
    var gt : (([Int]) -> Void)?
    
    var gHP : ((Double) -> Void)?
    var mDP : ((Double) -> Void)?
    var lP : ((Double) -> Void)?
    
    var startT : ((String) -> Void)?
    var middleT : ((String) -> Void)?
    var endT : ((String) -> Void)?
    
    //MARK: - Data Manipulations
    
    func priceQuote(symbol: String) {
        quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: symbol))
        quote.subscribe(onNext: { quote in
            self.c?(String(format: "%.2f", quote.c ?? 0.0))
            self.o?(String(format: "%.2f", quote.o ?? 0.0))
            self.l?(String(format: "%.2f", quote.l ?? 0.0))
            self.h?(String(format: "%.2f", quote.h ?? 0.0))
        }).disposed(by: self.disposeBag)
    }
    
    func companyData(symbol: String) {
        company = self.apiCalling.load(apiRequest: request.requestDataCompany(symbol: symbol))
        company.subscribe(onNext: { company in
            self.companyName?(company.name!)
            self.market?(String(company.marketCapitalization ?? 0.0))
            guard let noImage = URL(string: "https://static.finnhub.io/img/finnhub_2020-05-09_20_51/logo/logo-gradient-thumbnail-trans.png") else { return }
            self.downloadImage(from: URL(string: company.logo ?? noImage.absoluteString)!)
        }).disposed(by: self.disposeBag)
    }
    
    func requestStockHandleData(symbol: String,from: Int,to: Int) {
        stock = self.apiCalling.load(apiRequest: request.requestStockHandleData(symbol: symbol, from: from, to: to))
        stock.subscribe(onNext: { stock in
            self.gc?(stock.c)
            self.go?(stock.o)
            self.gt?(stock.t)
            
            let total = stock.c.reduce(0, +)
            self.mDP?(total / Double(stock.c.count))
            
            self.gHP?(stock.c.max()!)
            self.lP?(stock.c.min()!)
            
            let middle = stock.t.count / 2
            
            self.startT?(String(stock.t.first!.graphLabelDate()))
            self.middleT?(String(stock.t[middle].graphLabelDate()))
            self.endT?(String(stock.t.last!.graphLabelDate()))
            
        }).disposed(by: self.disposeBag)
    }
    
    func downloadImage(from url: URL) {
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .subscribe(onNext: { (response, data) in
                DispatchQueue.main.async {
                    self.image?(data)
                }
            }).disposed(by: self.disposeBag)
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
