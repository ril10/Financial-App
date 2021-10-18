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
    
    var disposeBag : DisposeBag!
    var result : [Result]!
    var requestservice : RequestService!
    
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
        let rs = requestservice
        
        return ResultSearchModel(symbol: symbol, companyName: companyName,requestService: rs!)
    }
    
    
    func searchResults(text: String) {
        DispatchQueue.main.async { [self] in
            requestservice.requestSearch(search: text)
                .subscribe(onNext:  { result in
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
