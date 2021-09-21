//
//  FinhubManager.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit

struct FinhubManager {
    
    private let apiKey = "c5474t2ad3ifdcrdfsmg"
    
    func loadSybmbolCompany(completion : @escaping ([SymbolCompany]) -> ()) {
        if let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US" + "&token=" + apiKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
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
    
    func loadDataCompany(completion : @escaping (FinhubCompany) -> (), ticker : String) {
        if let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=" + ticker + "&token=" + apiKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
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
    
    
    
    
}
