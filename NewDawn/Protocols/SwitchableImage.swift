//
//  SelectedButton.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 16/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Protocol that allows to change button image when user clicks.
/// it sets a choosen as Bool. When user selects it goes true.
protocol SwitchableImage {
  /// Selected state
  var choosen: Bool {get set}
  /// String for image Name
  var imageName: String {get set}
  /// Callback function
  func userDidSelect()
  /// set Image to original
  func reset()
}
