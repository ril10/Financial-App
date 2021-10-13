//
//  EnumApi.swift
//  Financial App
//
//  Created by administrator on 5.10.21.
//

import Foundation
import UIKit

enum UrlPath : String, CaseIterable {
    case base = "https://finnhub.io/api/v1/"
    case token = "&token=c5474t2ad3ifdcrdfsmg"
    case pathToSymbol = "stock/symbol?exchange=US"
    case pathCompany = "stock/profile2?symbol="
    case pathQuote = "quote?symbol="
    case pathCandle = "https://finnhub.io/api/v1/stock/candle?symbol="
    case pathCandleResolution = "&resolution=60&from="
    case pathCandleTo = "&to="
    case search = "search?q="
    case get = "GET"
    
}