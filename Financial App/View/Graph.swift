//
//  GraphView.swift
//  Financial App
//
//  Created by administrator on 23.09.21.
//

import UIKit

@IBDesignable

class Graph : UIView {
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    
    var c: [CGFloat] = [141.62,141.5,141.6,141.53,142,140.73,139.11,139.24,138.52,138.56,138.95,139.19,139.22,139.21,139.4,139.15]//close
    var h: [CGFloat] = [141.83,141.84,141.7,141.77,142.2,142.21,140.7,139.5,139.25,138.98,139.22,139.315,139.35,139.24,139.5,139.46]//high
    var l: [CGFloat] = [141.35,141.4,141.21,141.23,141.52,140.24,138.84,138.63,138.31,138.27,138.53,138.47,139.15,139.16,139.26,139.14]//low
    var o: [CGFloat] = [141.46,141.69,141.44,141.77,141.52,141.95,140.62,139.049,139.22,138.46,138.75,139.05,139.21,139.23,139.38,139.46]//open
    var t: [Int] = [1633334400,1633338000,1633341600,1633345200,1633348800,1633352400,1633356000,1633359600,1633363200,1633366800,1633370400,1633374000,1633377600,1633381200,1633384800,1633388400]//time in unix
    
    //symbol: AAPL resolution: 60 from:1633331689 to:1633418089

    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 50.0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        static let rectangleW: CGFloat = 10.0
        static let rectangleH: CGFloat = 20.0
    }
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //Gradient Background
        let colors = [startColor.cgColor, endColor.cgColor]
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )
        
        //X point
        // Calculate the x point
        
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.c.count)
            return CGFloat(column) * spacing + margin + 2
        }
        //Y Point
        let topBorder = c.max()! / 2
        let bottomBorder = (c.min()! / 2) - 20
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = c.max()
        let minValue = c.min()
        
        let columnYPoint = { (graphPoint: CGFloat) ->CGFloat in
            let yPoint = ((CGFloat(graphPoint) - minValue!) / (CGFloat(maxValue!) - CGFloat(minValue!))) * graphHeight
            return graphHeight + topBorder - yPoint
        }
        
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< c.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(c[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            if c.filter{o.contains($0)}.count > 1 {
                UIColor.red.setFill()
            } else {
                UIColor.green.setFill()
            }
            
            let rectangle = UIBezierPath(roundedRect: CGRect(x: point.x, y: point.y, width: Constants.rectangleW, height: Constants.rectangleH), cornerRadius: 2)
            rectangle.fill()
            
            let circle = UIBezierPath(ovalIn: CGRect( origin: point, size: CGSize( width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        
        // draw lines
        let linePath = UIBezierPath()
        
        // top Line
        linePath.move(to: CGPoint(x: 0, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        // mid Line
        linePath.move(to: CGPoint(x: 0, y: graphHeight / 2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder))
        
        // bottom Line
        linePath.move(to: CGPoint(x: 0, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
    }
    
    
    
    
}



