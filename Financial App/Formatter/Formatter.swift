//
//  Formatter.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import UIKit

extension Date {
    
    func dateFormatter() -> String {
        let time = self
        let formmater = DateFormatter()
        formmater.dateFormat = "MM-dd-yyyy HH:mm"
        let formatedDate = formmater.string(from: time)
        return formatedDate
    }
    
}

extension Int {
    
    func graphLabelDate() -> String {
        let unixTime = self
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        let dateForm = formatter.string(from: date)
        return dateForm
    }
    
}

