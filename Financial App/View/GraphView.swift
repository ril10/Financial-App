//
//  GraphView.swift
//  Financial App
//
//  Created by administrator on 23.09.21.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var days: [CGFloat] = [1, 2, 3, 4, 5, 6, 7, 8]
    var c: [CGFloat] = [141.62,141.5,141.6,141.53,142,140.73,139.11,139.24,138.52,138.56,138.95,139.19,139.22,139.21,139.4,139.15]//close
    var h: [CGFloat] = [141.83,141.84,141.7,141.77,142.2,142.21,140.7,139.5,139.25,138.98,139.22,139.315,139.35,139.24,139.5,139.46]//high
    var l: [CGFloat] = [141.35,141.4,141.21,141.23,141.52,140.24,138.84,138.63,138.31,138.27,138.53,138.47,139.15,139.16,139.26,139.14]//low
    var o: [CGFloat] = [141.46,141.69,141.44,141.77,141.52,141.95,140.62,139.049,139.22,138.46,138.75,139.05,139.21,139.23,139.38,139.46]//open
    var t: [Int] = [1633334400,1633338000,1633341600,1633345200,1633348800,1633352400,1633356000,1633359600,1633363200,1633366800,1633370400,1633374000,1633377600,1633381200,1633384800,1633388400]//time
    //symbol: AAPL resolution: 60 from:1633331689 to:1633418089
    // number of y axis labels
    let yDivisions: CGFloat = 5
    // margin between lines
    lazy var gap: CGFloat = {
        return bounds.height / (yDivisions + 1)
    }()
    lazy var bottomGap: CGFloat = {
        return bounds.height / (yDivisions + 1)
    }()
    // averaged value spread over y Divisions
    lazy var eachLabel: CGFloat = {
        let maxValue = CGFloat(c.max()!)
        return maxValue / (yDivisions-1)
    }()
    
    // column width
    lazy var columnWidth: CGFloat = {
        return bounds.width / CGFloat(c.count)
    }()
    
    
    lazy var data: [CGPoint] = {
        var array = [CGPoint]()
        for (index, day) in days.enumerated() {
            let point = CGPoint(x: columnWidth * CGFloat(index),
                                y: day / eachLabel * gap)
            array.append(point)
        }
        return array
    }()
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        let context2 = UIGraphicsGetCurrentContext()!
        


        drawTextLeft(context: context)
        drawTextBottom(context: context2)
        

        context.saveGState()
        context.translateBy(x: columnWidth/2+10, y: 0)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: bounds.height, y: -bounds.height)
        context.translateBy(x: 0, y: gap)
        
        
        context2.saveGState()
        context2.translateBy(x: 0, y: columnWidth/2+10)
        context2.scaleBy(x: 2, y: -1)
        context2.translateBy(x: -bounds.height, y: 0)
        context2.translateBy(x: bottomGap, y: 0)
        
        
    }
    func drawTextBottom(context: CGContext) {
        let font = UIFont(name: "Avenir-Light", size: 12)!
        let attributes = [NSAttributedString.Key.font: font]
        
        let minValue = CGFloat(days.min()!)
        context.saveGState()
        for i in 0..<8 {
            context.translateBy(x: bottomGap, y: 0)

            context.setStrokeColor(#colorLiteral(red: 0.8238154054, green: 0.8188886046, blue: 0.8286994696, alpha: 1).cgColor)
            context.setLineWidth(1)
            context.addLines(between: [CGPoint(x: 0, y: 35),
                                       CGPoint(x: 0, y: bounds.height)])
            context.strokePath()

            let text = "\(minValue + eachLabel * CGFloat(i))" as NSString
            let size = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: -size.height/2, y: 6), withAttributes: attributes)
        }
        context.restoreGState()
        
    }
    
    func drawTextLeft(context: CGContext) {
        let font = UIFont(name: "Avenir-Light", size: 12)!
        let attributes = [NSAttributedString.Key.font: font]
        
        let maxValue = CGFloat(c.max()!)
        context.saveGState()
        for i in 0..<5 {
            context.translateBy(x: 0, y: gap)
            
            context.setStrokeColor(#colorLiteral(red: 0.8238154054, green: 0.8188886046, blue: 0.8286994696, alpha: 1).cgColor)
            context.setLineWidth(1)
            context.addLines(between: [CGPoint(x: 35, y: 0),
                                       CGPoint(x: bounds.width, y: 0)])
            
            
            context.strokePath()
            
            let text = "\(maxValue - eachLabel * CGFloat(i))" as NSString
            let size = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: 6, y: -size.height/2), withAttributes: attributes)
            
        }
        context.restoreGState()
        
    }
    
}


