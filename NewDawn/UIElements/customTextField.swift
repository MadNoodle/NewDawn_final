//
//  customTextField.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 14/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
@IBDesignable
class CustomTextField: UITextField {
  @IBInspectable var dividerOffset: CGFloat = 0.0
  @IBInspectable var strokeWidth: CGFloat = 1.0
  @IBInspectable var color: UIColor = ColorTemplate.lightGreen
  
  override func layoutSubviews() {
    let separator = CAShapeLayer()
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: self.frame.height - dividerOffset))
    path.addLine(to: CGPoint(x: self.bounds.width, y: self.frame.height - dividerOffset))
    separator.path = path.cgPath
    separator.lineWidth = strokeWidth
    separator.strokeColor = color.cgColor
    self.layer.insertSublayer(separator, at: 0)
    self.borderStyle = .none
  }
}
