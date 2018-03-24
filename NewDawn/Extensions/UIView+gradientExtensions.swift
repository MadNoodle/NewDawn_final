//
//  UIView+gradientExtensions.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

extension UIView {
  
  func setGradientBackground(from startColor: CGColor, to endColor: CGColor ) {
    // Create Gradient
    let gradient = CAGradientLayer()
    // Cover whole Background
    gradient.frame = self.bounds
    layer.insertSublayer(gradient, at: 0)
    // Range of color
    gradient.colors = [startColor, endColor]
    
    // Coordinate of the gradients currently diagonal
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
    
    // Move the point to move the transitions
    gradient.locations = [0.0, 1.0]
  }
  
  func getGradientLayer(from startColor: CGColor, to endColor: CGColor ) -> CAGradientLayer {
    // Create Gradient
    let gradient = CAGradientLayer()
    // Cover whole Background
    gradient.frame = self.bounds
    
    // Range of color
    gradient.colors = [startColor, endColor]
    
    // Coordinate of the gradients currently diagonal
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
    
    // Move the point to move the transitions
    gradient.locations = [0.0, 1.0]
    return gradient
    
  }
}
