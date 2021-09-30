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
    var description : String
}

//MARK:CompanyInfo2 API
struct FinhubCompany : Codable {
    var country : String?
    var currency : String?
    var exchange : String?
    var ipo : String?
    var marketCapitalization : Double?
    var name : String?
    var shareOutstanding : Double?
    var ticker : String?
    var weburl : String?
    var logo : String?
    var finnhubIndustry : String?
}

//MARK:Stock Handels API
struct StockHandels : Codable {
    var c : [Double]
    var h : [Double]
    var l : [Double]
    var o : [Double]
    var s : String
    var t : [Int]
    var v : [Int]
}

//MARK:Quote
struct Quote : Codable {
    var c : Double?
    var h : Double?
    var l : Double?
    var o : Double?
}

//MARK:Basic Financials API

struct Series : Codable {
    var series : Annual
}

struct Annual : Codable {
    var annual : CurrentRatio
}

struct CurrentRatio : Codable {
    var currentRatio : [Period]
}

struct Period : Codable {
    var period : String
    var v : Double
}
