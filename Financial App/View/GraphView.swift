//
//  GraphView.swift
//  Financial App
//
//  Created by administrator on 23.09.21.
//

import UIKit

@IBDesignable
class GraphView: UIView {
  
  var days: [CGFloat] = [1, 4, 13, 3, 6, 5, 10, 8]
  
  var grpahPoints: [CGFloat] = [156.69,155.11,154.07,148.97,149.55,148.12,150.55,148.12]
    
  // number of y axis labels
  let yDivisions: CGFloat = 5
  // margin between lines
  lazy var gap: CGFloat = {
    return bounds.height / (yDivisions + 1)
  }()
  // averaged value spread over y Divisions
  lazy var eachLabel: CGFloat = {
    let maxValue = CGFloat(grpahPoints.max()!)
    return maxValue / (yDivisions-1)
  }()
  
  // column width
  lazy var columnWidth: CGFloat = {
    return bounds.width / CGFloat(grpahPoints.count)
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
    drawText(context: context)
    
    context.saveGState()
    context.translateBy(x: columnWidth/2+10, y: 0)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: -bounds.height)
    context.translateBy(x: 0, y: gap)
    
    // add clip
    context.saveGState()
    let clipPath = UIBezierPath()
    clipPath.interpolatePointsWithHermite(interpolationPoints: data)

    clipPath.addLine(to: CGPoint(x: bounds.width-columnWidth, y: 0))
    clipPath.addLine(to: .zero)
    clipPath.close()
    clipPath.addClip()
    
    
    drawGradient(context: context)
    context.restoreGState()
    
    
    context.addLines(between: data)
    context.strokePath()
    
    let path = UIBezierPath()
    path.interpolatePointsWithHermite(interpolationPoints: data)
    path.stroke()
    context.restoreGState()
    
  }
  
  func drawGradient(context: CGContext) {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colors: NSArray = [#colorLiteral(red: 0.811568439, green: 0.9574350715, blue: 0.9724325538, alpha: 1).cgColor, #colorLiteral(red: 0.3529999852, green: 0.7839999795, blue: 0.9800000191, alpha: 1).cgColor]
    let locations: [CGFloat] = [0.0, 0.75]
    let gradient = CGGradient(colorsSpace: colorSpace,
                              colors: colors,
                              locations: locations)
    let startPoint = CGPoint.zero
    let endPoint = CGPoint(x: 0, y: bounds.height)
    context.drawLinearGradient(gradient!,
                               start: startPoint,
                               end: endPoint, options: [])
    
    
    
  }
  
  func drawText(context: CGContext) {
    let font = UIFont(name: "Avenir-Light", size: 12)!
    let attributes = [NSAttributedString.Key.font: font]
    
    let maxValue = CGFloat(grpahPoints.max()!)
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

extension UIBezierPath
{
  func interpolatePointsWithHermite(interpolationPoints : [CGPoint], alpha : CGFloat = 1.0/3.0)
  {
    guard !interpolationPoints.isEmpty else { return }
    self.move(to: interpolationPoints[0])
    
    let n = interpolationPoints.count - 1
    
    for index in 0..<n
    {
      var currentPoint = interpolationPoints[index]
      var nextIndex = (index + 1) % interpolationPoints.count
      var prevIndex = index == 0 ? interpolationPoints.count - 1 : index - 1
      var previousPoint = interpolationPoints[prevIndex]
      var nextPoint = interpolationPoints[nextIndex]
      let endPoint = nextPoint
      var mx : CGFloat
      var my : CGFloat
      
      if index > 0
      {
        mx = (nextPoint.x - previousPoint.x) / 2.0
        my = (nextPoint.y - previousPoint.y) / 2.0
      }
      else
      {
        mx = (nextPoint.x - currentPoint.x) / 2.0
        my = (nextPoint.y - currentPoint.y) / 2.0
      }
      
      let controlPoint1 = CGPoint(x: currentPoint.x + mx * alpha, y: currentPoint.y + my * alpha)
      currentPoint = interpolationPoints[nextIndex]
      nextIndex = (nextIndex + 1) % interpolationPoints.count
      prevIndex = index
      previousPoint = interpolationPoints[prevIndex]
      nextPoint = interpolationPoints[nextIndex]
      
      if index < n - 1
      {
        mx = (nextPoint.x - previousPoint.x) / 2.0
        my = (nextPoint.y - previousPoint.y) / 2.0
      }
      else
      {
        mx = (currentPoint.x - previousPoint.x) / 2.0
        my = (currentPoint.y - previousPoint.y) / 2.0
      }
      
      let controlPoint2 = CGPoint(x: currentPoint.x - mx * alpha, y: currentPoint.y - my * alpha)
      self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
  }
}


