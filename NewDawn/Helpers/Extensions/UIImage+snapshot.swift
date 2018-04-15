///**
/**
NewDawn
Created by: Mathieu Janneau on 08/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit


  extension UIImage {
    convenience init(view: UIView) {
      UIGraphicsBeginImageContext(view.frame.size)
      view.layer.render(in:UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.init(cgImage: image!.cgImage!)
    }
  }


