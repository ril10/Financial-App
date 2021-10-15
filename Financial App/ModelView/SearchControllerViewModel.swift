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
    var search : Observable<ResultSearch>!
    var result : [Result]!
    
    var reloadTableView : (() -> Void)?
    
    var resultModel = [ResultSearchModel]() {
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
        resultModel = resData
    }
    
    func createCellModel(res: Result) -> ResultSearchModel {
        let symbol = res.symbol
        let companyName = res.description

        
        return ResultSearchModel(symbol: symbol, companyName: companyName)
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
        return resultModel[indexPath.row]
    }
    
    
}
