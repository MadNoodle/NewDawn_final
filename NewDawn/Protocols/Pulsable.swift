//
//  Pulsable.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 19/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

enum AnimationState {
  case animationInProgress
  case animationStopped
}

protocol Pulsable {
  var animationState: AnimationState {get set}
  var circles: [CAShapeLayer] {get set}
}

extension Pulsable where Self: UIView {
  
  mutating func performAnimation() {
    switch animationState {
    case .animationInProgress:
      print("c'est arreté")
      animationState = .animationStopped
      self.isHidden = true
    case .animationStopped:
      animationState = .animationInProgress
      print("ca roule")
      self.isHidden = false
    }
  }
}
