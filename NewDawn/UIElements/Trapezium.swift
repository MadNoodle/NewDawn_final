//
//  Trapezium.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class Trapezium: UIView {
  @IBInspectable var startColor:CGColor = ColorTemplate.darkGreen.cgColor
  @IBInspectable var endColor:CGColor = ColorTemplate.lightGreen.cgColor
  @IBInspectable var rigthOffset:CGFloat = 50
  @IBInspectable var leftOffset:CGFloat = 0
  
  override func draw(_ rect:CGRect){
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
