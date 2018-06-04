///**
/**
NewDawn
Created by: Mathieu Janneau on 27/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

/// Challenge Category Model
struct Category {
  var title: String
  var imageName: String
  
  /// Sends the Category name and icon
  ///
  /// - Returns: [Category]
  static func getCategories() -> [Category] {
    return [ Category(title: NSLocalizedString("Drive", comment: ""), imageName: UIConfig.driveThumbnail),
             Category(title: NSLocalizedString("Walk", comment: ""), imageName: UIConfig.walkThumbnail),
             Category(title: NSLocalizedString("Party", comment: ""), imageName: UIConfig.partyThumbnail),
             Category(title: NSLocalizedString("Transportation", comment: ""), imageName: UIConfig.transportThumbnail),
             Category(title: NSLocalizedString("Travel", comment: ""), imageName: UIConfig.travelThumbnail),
             Category(title: NSLocalizedString("Custom", comment: ""), imageName: UIConfig.customThumbnail)
      ]
  }
}
