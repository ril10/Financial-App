//
//  SearchControllerViewModel.swift
//  Financial App
//
//  Created by administrator on 14.10.21.
//

import Foundation
import Dip
import CoreData
import RxSwift


class SearchControllerViewModel {
    
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var request : APIRequest!
    var quote : Observable<Quote>!
    var search : Observable<ResultSearch>!
    var result : [Result]!
    
    var reloadTableView : (() -> Void)?
    
    var currentPrice : String?
    
    var resultViewModel = [ResultSearchModel]() {
        didSet {
            reloadTableView?()
        }
    }
    //MARK: - ConfigureCell
    func fetchData(res: [Result]) {
        var resData = [ResultSearchModel]()
        for r in res {
            resData.append(createCellModel(res: r))
        }
        resultViewModel = resData
    }
    
    func createCellModel(res: Result) -> ResultSearchModel {
        let symbol = res.symbol
        let companyName = res.description

//        DispatchQueue.main.async {
//            quote = self.apiCalling.load(apiRequest: request.requestQuote(symbol: symbol))
//            quote.subscribe(onNext: { quote in
//                self.currentPrice = String(format: "%.2f", quote.c ?? 0.0)
//        }).disposed(by: self.disposeBag)
//        }

        
        return ResultSearchModel(symbol: symbol, companyName: companyName, currentPrice: currentPrice ?? "0.0")
    }
    
    
    func searchResults(text: String) {
        DispatchQueue.main.async {
            self.search = self.apiCalling.load(apiRequest: self.request.requestSearch(search: text))
            self.search?.subscribe(onNext:  { result in
                if let searchResult = result.result {
                    self.fetchData(res: searchResult)
                }
            }).disposed(by: self.disposeBag)
        }
    }

    func getResultCellModel(at indexPath: IndexPath) -> ResultSearchModel {
        return resultViewModel[indexPath.row]
    }
    
    
}
