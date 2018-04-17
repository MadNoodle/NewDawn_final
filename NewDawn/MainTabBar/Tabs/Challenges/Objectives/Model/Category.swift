///**
/**
NewDawn
Created by: Mathieu Janneau on 27/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct Category {
  var title: ChallengeType
  var imageName: String
  
  static func getCategories() -> [Category] {
    return [ Category(title: .drive, imageName: UIConfig.driveThumbnail),
             Category(title: .walk, imageName: UIConfig.walkThumbnail),
             Category(title: .party, imageName: UIConfig.partyThumbnail),
             Category(title: .transport, imageName: UIConfig.transportThumbnail),
             Category(title: .travel, imageName: UIConfig.travelThumbnail)
      ]
  }
}
