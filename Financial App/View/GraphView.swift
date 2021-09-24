//
//  GraphView.swift
//  Financial App
//
//  Created by administrator on 23.09.21.
//

import UIKit


@IBDesignable
class GraphView: UIView {
    
    var graphPoints = [Double]()
    
    private enum Constants {
        static let margin: CGFloat = 150
        static let topBorder: CGFloat = 146
        static let bottomBorder: CGFloat = 146
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
        
    @IBInspectable var startColor : UIColor = .white
    @IBInspectable var endColor : UIColor = .white
    
    @IBInspectable var graphStartColor : UIColor = .green
    @IBInspectable var graphEndColor : UIColor = .white
    
//    var graphPoints = [145.1,145.3,145.6,145.1,145.2]
    var topBorder : CGFloat = 0.0
    var bottomBorder : CGFloat = 0.0
    
    var td = TickDetail()

    let splitCount = 5
    
    override func draw(_ rect: CGRect) {
        
        
        let width = rect.width
        let height = rect.height
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations : [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else {
            return
        }
        
        let graphColors = [graphStartColor.cgColor, graphEndColor.cgColor]
        
        let graphColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let graphColorLocations : [CGFloat] = [0.0,0.5,1.0]
        
        guard let graphGradient = CGGradient(colorsSpace: graphColorSpace, colors: graphColors as CFArray, locations: graphColorLocations) else {
            return
        }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        //x point
        let margin = Constants.margin
        let graphWidth = width / 10 - (margin * 2.0 - 4.0)
        let columnXPoint = { (column: Double) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        //y point
        let topBorder = topBorder
        let bottomBorder = bottomBorder
        let graphHeight = height * 1000 - topBorder + bottomBorder
        guard let maxValue = graphPoints.max() else {
            return
        }
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yPoint
        }
        
        UIColor.systemGreen.setFill()
        UIColor.systemGreen.setStroke()
        
        
        let graphPath = UIBezierPath()
        
        
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        
        for i in 1 ..< graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        context.saveGState()
        
        
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        
        clippingPath.addLine(to: CGPoint(
                                x: columnXPoint(Double(graphPoints.count - 1)),
                                y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        
        clippingPath.addClip()
        
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(
            graphGradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        context.restoreGState()
        
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< graphPoints.count {
            var point = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point,
                    size: CGSize(
                        width: Constants.circleDiameter,
                        height: Constants.circleDiameter)
                )
            )
            circle.fill()
        }
        
        let linePath = UIBezierPath()
        linePath.lineWidth = 0.5

        UIColor.lightGray.setStroke()
        for x in 0...splitCount {
            for y in 0...splitCount {
                if x != y, x == 0, y < splitCount {
                    linePath.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
                    linePath.addLine(to: getPoint(rect, x: CGFloat(splitCount), y: CGFloat(y)))
                    linePath.stroke()
                } else if y != x, y == 0, x < splitCount {
                    linePath.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
                    linePath.addLine(to: getPoint(rect, x: CGFloat(x), y: CGFloat(splitCount)))
                    linePath.stroke()
                }
            }
        }

        func getPoint(_ rect: CGRect, x: CGFloat, y: CGFloat) -> CGPoint {
            let width = rect.width / CGFloat(splitCount)
            let height = rect.height / CGFloat(splitCount)
            return CGPoint(x: width * x, y: height * y)
        }
        
    }
    
}
