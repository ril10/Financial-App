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
    var queryToken : URLQueryItem
    let token : String
    var components = URLComponents()
    
    init() {
        token = UIApplication.token!
        components.scheme = "https"
        components.host = UIApplication.baseUrl
        queryToken = URLQueryItem(name: "token", value: token)
    }
    
    private func getRequestUrl(path: String,queryItem: URLQueryItem...) -> URLRequest {
        var item = queryItem
        item.append(queryToken)
        components.path = path
        components.queryItems = item
        return URLRequest(url: components.url!)
    }
    
    func requestDataCompany(symbol: String) -> URLRequest {
        let queryItemSymbol = URLQueryItem(name: EnumQuery.symbol.rawValue, value: symbol)
        let path = UIApplication.basePath! + UrlPath.pathCompany.rawValue
        var request = getRequestUrl(path: path, queryItem: queryItemSymbol)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }

    func requestQuote(symbol: String) -> URLRequest {
        let queryItemSymbol = URLQueryItem(name: EnumQuery.symbol.rawValue, value: symbol)
        let path = UIApplication.basePath! + UrlPath.pathQuote.rawValue
        var request = getRequestUrl(path: path, queryItem: queryItemSymbol)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
    func requestSearch(search: String) -> URLRequest {
        let queryItemSymbol = URLQueryItem(name: EnumQuery.q.rawValue, value: search)
        let path = UIApplication.basePath! + UrlPath.search.rawValue
        var request = getRequestUrl(path: path, queryItem: queryItemSymbol)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
    func requestStockHandleData(symbol: String,from: Int,to: Int) -> URLRequest {
        let path = UIApplication.basePath! + UrlPath.pathStock.rawValue
        let queryItemSymbol = URLQueryItem(name: EnumQuery.symbol.rawValue, value: symbol)
        let queryResoluiton = URLQueryItem(name: EnumQuery.resolution.rawValue, value: EnumQuery.res60.rawValue)
        let queryFrom = URLQueryItem(name: EnumQuery.from.rawValue, value: String(from))
        let quryTo = URLQueryItem(name: EnumQuery.to.rawValue, value: String(to))
        var request = getRequestUrl(path: path, queryItem: queryItemSymbol,queryResoluiton,queryFrom,quryTo)
        request.httpMethod = UrlPath.get.rawValue
        return request
    }
    
}

