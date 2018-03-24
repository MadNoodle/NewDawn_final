//
//  GreenGradient.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit

@IBDesignable
class GradientButton: UIButton {
  var startColor: CGColor = ColorTemplate.darkGreen.cgColor
  var endColor: CGColor = ColorTemplate.lightGreen.cgColor
  
  override func draw(_ rect: CGRect) {
    setGradientBackground(from: startColor, to: endColor)
    // Round corners
    layer.cornerRadius = 5
    layer.masksToBounds = true
  }
}
