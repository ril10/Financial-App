//
//  FinhubManager.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit
import RxSwift
import RxCocoa


struct FinhubManager {
    
    //MARK: - SymbolParse
    func loadSybmbolCompany(completion : @escaping ([SymbolCompany]) -> ()) {
        
        if let url = URL(string: UrlPath.base.rawValue + UrlPath.pathToSymbol.rawValue + UrlPath.token.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = UrlPath.get.rawValue
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let data = try JSONDecoder().decode([SymbolCompany].self, from: safeData)
                        completion(data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - AboutCompany
    func loadDataCompany(ticker : String, completion : @escaping (FinhubCompany) -> ()) {
        if let url = URL(string: UrlPath.base.rawValue + UrlPath.pathCompany.rawValue + ticker + UrlPath.token.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = UrlPath.get.rawValue
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let data = try JSONDecoder().decode(FinhubCompany.self, from: safeData)
                        completion(data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Quote
    func loadQuote(ticker: String, completion : @escaping (Quote) -> ()) {
        if let url = URL(string: UrlPath.base.rawValue + UrlPath.pathQuote.rawValue + ticker + UrlPath.token.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = UrlPath.get.rawValue
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let data = try JSONDecoder().decode(Quote.self, from: safeData)
                        completion(data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    //MARK: - Get Image Data
    func getDataImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: - Search
    func searchFinhub(search: String, completion : @escaping (ResultSearch) -> ()) {
        if let url = URL(string: UrlPath.base.rawValue + UrlPath.search.rawValue + search + UrlPath.token.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = UrlPath.get.rawValue
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let data = try JSONDecoder().decode(ResultSearch.self, from: safeData)
                        completion(data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - StockCandleData
    func loadStockCandle(symbol: String,from: Int,to: Int, completion : @escaping (StockHandelData) -> ()) {
        if let url = URL(string: UrlPath.pathCandle.rawValue + symbol + UrlPath.pathCandleResolution.rawValue + "\(from)" +  UrlPath.pathCandleTo.rawValue + "\(to)" + UrlPath.token.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = UrlPath.get.rawValue
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let data = try JSONDecoder().decode(StockHandelData.self, from: safeData)
                        completion(data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
}


