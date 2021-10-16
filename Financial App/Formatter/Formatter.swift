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

extension UITableViewCell {
    func addShadow(view: UIView, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 5, shadowOpacity: Float = 0.1, shadowPathInset: (dx: CGFloat, dy: CGFloat), shadowPathOffset: (dx: CGFloat, dy: CGFloat)) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy).offsetBy(dx: shadowPathOffset.dx, dy: shadowPathOffset.dy), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = backgroundColor
        whiteBackgroundView.layer.cornerRadius = cornerRadius
        whiteBackgroundView.layer.masksToBounds = true
        whiteBackgroundView.clipsToBounds = false
        
        whiteBackgroundView.frame = bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy)
        insertSubview(whiteBackgroundView, at: 0)
    }
}

