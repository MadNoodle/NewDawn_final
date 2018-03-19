//
//  PulsatingCircles.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 19/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class PulsatingCircles: UIView,Pulsable {
  
  @IBInspectable var radius1: CGFloat = 0
  @IBInspectable var stroke1: CGFloat = 0
  @IBInspectable var radius2: CGFloat = 0
  @IBInspectable var stroke2: CGFloat = 0
  @IBInspectable var radius3: CGFloat = 0
  @IBInspectable var stroke3: CGFloat = 0
  @IBInspectable var radius4: CGFloat = 0
  @IBInspectable var stroke4: CGFloat = 0
  @IBInspectable var radius5: CGFloat = 0
  @IBInspectable var stroke5: CGFloat = 0
  @IBInspectable var circlesColor : UIColor = UIColor(white: 1, alpha: 0.5)
  
  
  var animationState: AnimationState = .animationStopped
  var circles: [CAShapeLayer] = []
  let label = UILabel()
  
  
  override func draw(_ rect: CGRect) {
    addLabel()
    addCircles()
  }
  
  fileprivate func addLabel() {
    
    label.text = "Inhale"
    label.textColor = .white
    label.font = UIFont(name: "TitilliumWeb-Light", size: 17.0)
    label.center = self.center
    label.textAlignment = .center
    label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    self.addSubview(label)
  }
  
  fileprivate func addCircles() {
    let circlePropertiesArray: [(CGFloat,CGFloat)] = [(radius1,stroke1),(radius2,stroke2),(radius3,stroke3),(radius4,stroke4),(radius5,stroke5)]
    
    let newCenter = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    
    for props in circlePropertiesArray{
      if props.0 != 0 {
        let pulsatingCircle = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: props.0, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
        pulsatingCircle.path = circularPath.cgPath
        pulsatingCircle.lineWidth = props.1
        circles.append(pulsatingCircle)}
    }
    
    for circle in circles {
      circle.position = newCenter
      circle.strokeColor = circlesColor.cgColor
      circle.fillColor = UIColor.clear.cgColor
      circle.lineCap = kCALineCapRound
      self.layer.addSublayer(circle)
    }
  }
}
