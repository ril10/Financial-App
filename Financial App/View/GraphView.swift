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
      static let margin: CGFloat = 0.0
      static let topBorder: CGFloat = 121
      static let bottomBorder: CGFloat = 118
      static let colorAlpha: CGFloat = 0.3
      static let circleDiameter: CGFloat = 5.0
    }
        
    @IBInspectable var startColor : UIColor = .white
    @IBInspectable var endColor : UIColor = .white
    
    @IBInspectable var graphStartColor : UIColor = .green
    @IBInspectable var graphEndColor : UIColor = .white
    
//    var graphPoints = [    0.0,119.12,119.08,119.14,119.19,119.06,119.1,118.9,118.87,118.93,118.95,119.01,118.99,118.88,118.88,118.72,118.67,118.84,118.7,119.11,119.04,118.99,119.29,118.93,118.86,119.34,119.36,119.34,119.4,119.4,119.45,119.38,119.16,118.96,118.89,118.93,119.06,119.15,119.3, 119.36,119.43,119.29, 119.24,119.32,119.7,119.88,119.94, 119.93, 119.99,120.38,120.27,120.45,120.57,120.63, 120.67,120.73,120.65,120.74,120.57,120.52,120.54]
    
    var topBorder : CGFloat = 0.0
    var bottomBorder : CGFloat = 0.0
    
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
        
        // Calculate the x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Double) -> CGFloat in
          // Calculate the gap between points
          let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
          return CGFloat(column) * spacing + margin + 2
        }
        // Calculate the y point
            
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height * topBorder + bottomBorder
        guard let maxValue = graphPoints.max() else {
          return
        }
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
            let yPoint = (CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight)
          return graphHeight + topBorder - yPoint // Flip the graph
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
            
        // Set up the points line
        let graphPath = UIBezierPath()

        // Go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
            
        // Add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(Double(graphPoints[i])))
          graphPath.addLine(to: nextPoint)
        }

        graphPath.stroke()

        // Create the clipping path for the graph gradient

        
        context.saveGState()
            
        
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
          return
        }
            
        
        clippingPath.addLine(to: CGPoint(
                                x: columnXPoint(Double(graphPoints.count) - 1.0),
          y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
            
        
        clippingPath.addClip()
            
       
        UIColor.green.setFill()
        let rectPath = UIBezierPath(rect: rect)
        rectPath.fill()
        // End temporary code
        let highestYPoint = columnYPoint(Double(Int(maxValue)))
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
                
        context.drawLinearGradient(
          gradient,
          start: graphStartPoint,
          end: graphEndPoint,
          options: [])
        context.restoreGState()

        // Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(Double(Int(graphPoints[i]))))
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
        
//        let linePath = UIBezierPath()
//        linePath.lineWidth = 0.5
//
//        UIColor.lightGray.setStroke()
//        for x in 0...splitCount {
//            for y in 0...splitCount {
//                if x != y, x == 0, y < splitCount {
//                    linePath.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
//                    linePath.addLine(to: getPoint(rect, x: CGFloat(splitCount), y: CGFloat(y)))
//                    linePath.stroke()
//                } else if y != x, y == 0, x < splitCount {
//                    linePath.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
//                    linePath.addLine(to: getPoint(rect, x: CGFloat(x), y: CGFloat(splitCount)))
//                    linePath.stroke()
//                }
//            }
//        }
//
//        func getPoint(_ rect: CGRect, x: CGFloat, y: CGFloat) -> CGPoint {
//            let width = rect.width / CGFloat(splitCount)
//            let height = rect.height / CGFloat(splitCount)
//            return CGPoint(x: width * x, y: height * y)
//        }
        
    }
    
}
