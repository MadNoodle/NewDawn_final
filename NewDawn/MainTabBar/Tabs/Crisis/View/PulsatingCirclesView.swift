///**
/**
NewDawn
Created by: Mathieu Janneau on 27/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class PulsatingCirclesView: UIView {

  var radius: [CGFloat] = [1,0.80,0.60,0.40,0.24]
  var circles = [CAShapeLayer]()
  

  override func draw(_ rect: CGRect) {
  
    // Define Common center for all the circles
    let newCenter = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    
    // Create all the Circle paths according to the different radius
    for rad in radius {
      
      let pulsatingCircle = CAShapeLayer()
      pulsatingCircle.frame = self.bounds
      let circularPath = UIBezierPath(arcCenter: newCenter,
                                      radius: rad * self.bounds.width / 2 ,
                                      startAngle: 0,
                                      endAngle: CGFloat(2 * Float.pi),
                                      clockwise: true)
      pulsatingCircle.path = circularPath.cgPath
      pulsatingCircle.frame = self.bounds
      pulsatingCircle.fillColor = UIColor(white: 1, alpha: 0.2).cgColor
      circles.append(pulsatingCircle)
    }
    
    // Adding the Circles to the View
    for circle in circles {
      circle.position = newCenter
      circle.lineCap = kCALineCapRound
      self.layer.addSublayer(circle)
    }
  }
  
    func circlesAnimation(for cycles: Float) {
      // initial position
      self.transform = CGAffineTransform.init(scaleX: 0.24, y: 0.24)
  
      UIView.animateKeyframes(withDuration: 12.0, delay: 0, options: [ .calculationModeCubicPaced], animations: {
        //repeat
        UIView.setAnimationRepeatCount(Float(cycles))
  
        // step number 1
        UIView.addKeyframe(withRelativeStartTime: 0.0/12.0, relativeDuration: 4.0/12.0, animations: {
          self.transform = CGAffineTransform.identity
        })
  
        // step number 2
        UIView.addKeyframe(withRelativeStartTime: 5.0/12.0, relativeDuration: 7.0/12.0, animations: {
          self.transform = CGAffineTransform.init(scaleX: 0.24, y: 0.24)
        })
      })
    }
  
    func resetCirclesAnimation() {
      UIView.animate(withDuration: 2, animations: {
        self.transform = CGAffineTransform.identity
      })
    }

  
 

}
