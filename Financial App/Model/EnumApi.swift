//
//  EnumApi.swift
//  Financial App
//
//  Created by administrator on 5.10.21.
//

import Foundation

enum ApiKey: String, CaseIterable {
    case apiKey = "c5474t2ad3ifdcrdfsmg"
}

enum UrlPath : String, CaseIterable {
    case base = "https://finnhub.io/api/v1/"
    case token = "&token="
    case pathToSymbol = "stock/symbol?exchange=US"
    case pathCompany = "stock/profile2?symbol="
    case pathQuote = "quote?symbol="
    case search = "search?q="

}
