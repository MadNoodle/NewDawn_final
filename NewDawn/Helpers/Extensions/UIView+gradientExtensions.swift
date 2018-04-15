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

extension UIView {
  
  /// Create snapshot
  ///
  /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
  ///                   return snapshot of the whole view.
  ///
  /// - returns: Returns `UIImage` of the specified portion of the view.
  
  func snapshot(of rect: CGRect? = nil) -> UIImage? {
    // snapshot entire view
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // if no `rect` provided, return image of whole view
    
    guard let image = wholeImage, let rect = rect else { return wholeImage }
    
    // otherwise, grab specified `rect` of image
    
    let scale = image.scale
    let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
    guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
    return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
  }
  
}
