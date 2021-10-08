//
//  FinhubRxRequests.swift
//  Financial App
//
//  Created by administrator on 8.10.21.
//

import UIKit
import RxSwift

class APICalling {
    
    func load<T: Codable>(apiRequest: URLRequest) -> Observable<T> {
        return Observable<T>.create {observer in
            let task = URLSession.shared.dataTask(with: apiRequest) { (data, response, error) in
                do {
                    let model : T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}

class APIRequest {

    func requestDataCompany(symbol: String) -> URLRequest {
        var request = URLRequest(url:URL(string: UrlPath.base.rawValue + UrlPath.pathCompany.rawValue + "\(symbol)" + UrlPath.token.rawValue)!)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }

    func requestQuote(symbol: String) -> URLRequest {
        var request = URLRequest(url:URL(string: UrlPath.base.rawValue + UrlPath.pathQuote.rawValue + symbol + UrlPath.token.rawValue)!)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
    func requestSearch(search: String) -> URLRequest {
        guard let url = URL(string: UrlPath.base.rawValue + UrlPath.search.rawValue + search + UrlPath.token.rawValue) else { return URLRequest(url: URL(string: UrlPath.base.rawValue)!) }
        var request = URLRequest(url: url)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
    func requestStockHandleData(symbol: String,from: Int,to: Int) -> URLRequest {
        var request = URLRequest(url:URL(string: UrlPath.pathCandle.rawValue + symbol + UrlPath.pathCandleResolution.rawValue + "\(from)" +  UrlPath.pathCandleTo.rawValue + "\(to)" + UrlPath.token.rawValue)!)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
}

