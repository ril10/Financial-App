//
//  StockHandleData.swift
//  Financial App
//
//  Created by Sergey Luk on 7.10.21.
//

import Foundation


//MARK:Stock Handels API
struct StockHandelData : Codable {
    var c : [Double]
    var h : [Double]
    var l : [Double]
    var o : [Double]
    var s : String
    var t : [Int]
    var v : [Int]
}

