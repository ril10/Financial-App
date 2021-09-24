//
//  WebstockTrades.swift
//  Financial App
//
//  Created by administrator on 24.09.21.
//

import Foundation

//MARK: Websocket trades

struct Websocket : Codable {
    var data : [DataWebsocket]
    let type: String
}
struct DataWebsocket : Codable {
    let c: [String]
    let p: Double
    let s: String
    let t, v: Int
}
