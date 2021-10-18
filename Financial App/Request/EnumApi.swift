//
//  EnumApi.swift
//  Financial App
//
//  Created by administrator on 5.10.21.
//

import Foundation


enum UrlPath : String, CaseIterable {
    case pathCompany = "stock/profile2"
    case pathQuote = "quote"
    case pathStock = "stock/candle"
    case search = "search"
    case get = "GET"
}
