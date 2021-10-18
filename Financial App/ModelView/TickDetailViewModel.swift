//
//  TickDetailViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import Dip
import RxSwift
import RxCocoa
import CoreData


class TickDetailViewModel {
    
    var disposeBag : DisposeBag!
    var lots : [Lots]!
    var context : NSManagedObjectContext!
    var requestservice : RequestService!
    
    
    var reloadView : (() -> Void)?
    
    var symbol : String! {
        didSet {
            reloadView?()
        }
    }
    //Company
    var companyData : ((String,String) -> Void)?
    var image : ((Data) -> Void)?
    //Quote
    var quot : ((String,String,String,String) -> Void)?
    //Stock
    var graphData : (([Double],[Double],[Int]) -> Void)?
    var graphLabel : ((Double,Double,Double) -> Void)?
    var graphTime : ((String,String,String) -> Void)?
    
    
    //MARK: - Data Manipulations
    
    func priceQuote(symbol: String) {
        requestservice.requestQuote(symbol: symbol)
            .subscribe(onNext: { quote in
                self.quot?(String(format: "%.2f", quote.c ?? 0.0),String(format: "%.2f", quote.o ?? 0.0),String(format: "%.2f", quote.l ?? 0.0),String(format: "%.2f", quote.h ?? 0.0))
                self.reloadView?()
            }).disposed(by: self.disposeBag)
    }
    
    func companyData(symbol: String) {
        requestservice.requestDataCompany(symbol: symbol)
            .subscribe(onNext: { company in
                self.companyData?(company.name!, String(company.marketCapitalization ?? 0.0))
                guard let noImage = URL(string: NoImage.noImage.rawValue) else { return }
                self.downloadImage(from: URL(string: company.logo ?? noImage.absoluteString)!)
                self.reloadView?()
            }).disposed(by: self.disposeBag)
    }
    
    func requestStockHandleData(symbol: String,from: Int,to: Int) {
        requestservice.requestStockHandel(symbol: symbol, from: from, to: to)
            .subscribe(onNext: { stock in
                self.graphData?(stock.c,stock.o,stock.t)
                
                let total = stock.c.reduce(0, +)
                self.graphLabel?( (total / Double(stock.c.count)) ,stock.c.max()!, stock.c.min()!)
                
                let middle = stock.t.count / 2
                self.graphTime?(String(stock.t.first!.graphLabelDate()) ,String(stock.t[middle].graphLabelDate()) ,String(stock.t.last!.graphLabelDate()) )
                
                self.reloadView?()
            }).disposed(by: self.disposeBag)
    }
    
    func downloadImage(from url: URL) {
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .subscribe(onNext: { (response, data) in
                DispatchQueue.main.async {
                    self.image?(data)
                    self.reloadView?()
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
