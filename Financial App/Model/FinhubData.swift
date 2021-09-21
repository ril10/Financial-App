//
//  Finhub.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import Foundation


//MARK:SymbolCompany

struct SymbolCompany : Codable {
    var symbol : String
}

//MARK:CompanyInfo2 API
struct FinhubCompany : Codable {
    var country : String
    var currency : String
    var exchange : String
    var ipo : String
    var marketCapitalization : Double
    var name : String
    var shareOutstanding : Double
    var ticker : String
    var weburl : String
    var logo : String
    var finnhubIndustry : String
}

//MARK:Stock Handels API
struct StockHandels {
    var c : [Float]
    var h : [Float]
    var l : [Float]
    var o : [Float]
    var s : String
    var t : [Int]
    var v : [Int]
}

//MARK:Basic Financials API
struct Series {
    var annual : [AnnualFin]
}

struct AnnualFin {
    var currentRatio : [CurrentRatio]
}

struct CurrentRatio {
    var period : Date
    var v : Float
}
