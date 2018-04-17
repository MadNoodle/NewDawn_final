//
//  Trapezium.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit

/// Customizable trapezium shape with a color graident background
@IBDesignable
class Trapezium: UIView {
  
  /// Start color for the background gradient
  var startColor: CGColor = UIConfig.lightGreen.cgColor
  /// end color for the background gradient
  var endColor: CGColor = UIConfig.lightGreen.cgColor
  /// Offset por the bottom rigth CGPoint to customize the trapezium
  @IBInspectable var rigthOffset: CGFloat = 50
  /// Offset por the bottom left CGPoint to customize the trapezium
  @IBInspectable var leftOffset: CGFloat = 0
  
  override func draw(_ rect: CGRect) {
    // Draw trapezoid shape
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
    path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - rigthOffset))
    path.addLine(to: CGPoint(x: 0, y: self.bounds.height - leftOffset))
    path.close()
    
    // Set background gradient
    let gradient: CAGradientLayer = getGradientLayer(from: startColor, to: endColor)
    gradient.frame = self.bounds
    layer.insertSublayer(gradient, at: 0)
    
    //Mask
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    self.layer.mask = shapeLayer
  }
}
