//
//  roundedImage.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 14/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
@IBDesignable
class RoundedImage: UIImageView {
  override init(image: UIImage?) {
    super.init(image: image)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    self.layer.cornerRadius = self.frame.size.height / 2
    self.clipsToBounds = true
  }
}
