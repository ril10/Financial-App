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
    
    
    var c = [Double]()//close
    var o = [Double]()//open
    var t = [Int]()

    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 40.0
        static let colorAlpha: CGFloat = 0.3
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
        let graphWidth = width - margin * 2 - 20
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.c.count)
            return CGFloat(column) * spacing + margin + 2
        }
        //Xo point
        // Calculate the x point
        
        let columnXOPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.o.count)
            return CGFloat(column) * spacing + margin + 20
        }
        //Y Point
        let topBorder = CGFloat(c.max() ?? 0 / 2)
        let bottomBorder = CGFloat((c.min() ?? 0 / 2) + 30)
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = CGFloat(c.max() ?? 0)
        let minValue = CGFloat(c.min() ?? 0)
        
        let columnYPoint = { (graphPoint: CGFloat) ->CGFloat in
            let yPoint = ((CGFloat(graphPoint) - minValue) / (CGFloat(maxValue) - CGFloat(minValue))) * graphHeight
            return graphHeight + topBorder - yPoint
        }
        //Oy Point
        let maxValueOpoint = CGFloat(o.max() ?? 0)
        let minValueOpoint = CGFloat(o.min() ?? 0)
        
        let columnOPoint = { (graphPoint: CGFloat) ->CGFloat in
            let yPoint = ((CGFloat(graphPoint) - minValueOpoint) / (CGFloat(maxValueOpoint) - CGFloat(minValueOpoint))) * graphHeight
            return graphHeight + topBorder - yPoint
        }
        
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< c.count {
            let point = CGPoint(x: columnXPoint(i), y: columnYPoint(CGFloat(c[i])))

            let rectangle = UIBezierPath(roundedRect: CGRect(x: point.x, y: point.y, width: Constants.rectangleW, height: Constants.rectangleH), cornerRadius: 2)
            UIColor.red.setFill()
            rectangle.fill()
        
        }
        for i in 0 ..< o.count {
            let pointO = CGPoint(x: columnXOPoint(i), y: columnOPoint(CGFloat(o[i])))
            
            let rectangleO = UIBezierPath(roundedRect: CGRect(x: pointO.x, y: pointO.y, width: Constants.rectangleW, height: Constants.rectangleH), cornerRadius: 2)
            UIColor.green.setFill()
            rectangleO.fill()
        }

        
    }

}



