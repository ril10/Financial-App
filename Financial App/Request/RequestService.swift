//
//  RequestService.swift
//  Financial App
//
//  Created by administrator on 18.10.21.
//

import Foundation
import RxSwift
import Dip

class RequestService {
    
    init(apiCalling: APICalling, apiRequest: APIRequest) {
        self.apiCalling = apiCalling
        self.apiRequest = apiRequest
    }
    
    let apiCalling : APICalling!
    let apiRequest : APIRequest!
    
    func requestSearch(search: String) -> Observable<ResultSearch> {
        let request = apiRequest.requestSearch(search: search)
        return apiCalling.load(apiRequest: request)
    }
    
    func requestQuote(symbol: String) -> Observable<Quote> {
        let request = apiRequest.requestQuote(symbol: symbol)
        return apiCalling.load(apiRequest: request)
    }
    
    func requestDataCompany(symbol: String) -> Observable<FinhubCompany> {
        let request = apiRequest.requestDataCompany(symbol: symbol)
        return apiCalling.load(apiRequest: request)
    }
    
    func requestStockHandel(symbol: String, from: Int, to: Int) -> Observable<StockHandelData> {
        let request = apiRequest.requestStockHandleData(symbol: symbol, from: from, to: to)
        return apiCalling.load(apiRequest: request)
    }
    
}
