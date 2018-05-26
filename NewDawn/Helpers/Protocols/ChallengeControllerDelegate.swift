///**
/**
 NewDawn
 Created by: Mathieu Janneau on 29/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */

import Foundation
import UIKit
protocol ChallengeControllerDelegate: class {
  func sendCategory() -> String?
}

extension ChallengeControllerDelegate {
  func sendCategory() -> String? { return nil}
}
