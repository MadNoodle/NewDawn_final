///**
/**
NewDawn
Created by: Mathieu Janneau on 08/04/2018
Copyright (c) 2018 Mathieu Janneau
*/

import UIKit

/// This extension create UIImage by making a a screenshot of UIView
  extension UIImage {
    convenience init(view: UIView) {
      UIGraphicsBeginImageContext(view.frame.size)
      view.layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.init(cgImage: image!.cgImage!)
    }
  }
