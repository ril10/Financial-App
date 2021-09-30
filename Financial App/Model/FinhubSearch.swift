//
//  FinhubSearch.swift
//  Financial App
//
//  Created by Sergey Luk on 25.09.21.
//

import Foundation

struct ResultSearch : Codable {
    var count : Int?
    var result : [Result]?
}

struct Result : Codable {
    var description : String
    var displaySymbol : String
    var symbol : String
    var type : String
}
