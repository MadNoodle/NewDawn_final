///**
/**
NewDawn
Created by: Mathieu Janneau on 25/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import MapKit

class AnnotationView: MKAnnotationView {
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    if hitView != nil {
      self.superview?.bringSubview(toFront: self)
    }
    return hitView
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let rect = self.bounds
    var isInside: Bool = rect.contains(point)
    if !isInside {
      for view in self.subviews {
        isInside = view.frame.contains(point)
        if isInside {
          break
        }
      }
    }
    return isInside
  }
}
