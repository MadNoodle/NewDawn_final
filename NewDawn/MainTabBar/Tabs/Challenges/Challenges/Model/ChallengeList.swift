///**
/**
NewDawn
Created by: Mathieu Janneau on 28/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct ChallengeList {
  
  static func getChallenges(for category: String ) -> [String] {
    
    switch category {
    case NSLocalizedString("Drive", comment: ""):
      return [NSLocalizedString("drivingOne", comment: ""), NSLocalizedString("drivingOTwo", comment: ""), NSLocalizedString("drivingThree", comment: ""), NSLocalizedString("drivingFour", comment: ""), NSLocalizedString("drivingFive", comment: ""), NSLocalizedString("drivingSix", comment: ""), NSLocalizedString("drivingSeven", comment: ""), NSLocalizedString("drivingEight", comment: "")]
    case NSLocalizedString("Travel", comment: ""):
      return [NSLocalizedString("travelOne", comment: ""), NSLocalizedString("travelOTwo", comment: ""), NSLocalizedString("travelThree", comment: ""), NSLocalizedString("travelFour", comment: ""), NSLocalizedString("travelFive", comment: ""), NSLocalizedString("travelSix", comment: ""), NSLocalizedString("travelSeven", comment: ""), NSLocalizedString("travelEight", comment: "")]
    case NSLocalizedString("Walk", comment: ""):
      return [NSLocalizedString("walkOne", comment: ""), NSLocalizedString("walkOTwo", comment: ""), NSLocalizedString("walkThree", comment: ""), NSLocalizedString("walkFour", comment: ""), NSLocalizedString("walkFive", comment: ""), NSLocalizedString("walkSix", comment: ""), NSLocalizedString("walkSeven", comment: ""), NSLocalizedString("walkEight", comment: "")]
    case NSLocalizedString("Transportation", comment: ""):
      return [NSLocalizedString("transportOne", comment: ""), NSLocalizedString("transportOTwo", comment: ""), NSLocalizedString("transportThree", comment: ""), NSLocalizedString("transportFour", comment: ""), NSLocalizedString("transportFive", comment: ""), NSLocalizedString("transportSix", comment: ""), NSLocalizedString("transportSeven", comment: ""), NSLocalizedString("transportEight", comment: "")]
    case NSLocalizedString("Party", comment: ""):
      return [NSLocalizedString("partyOne", comment: ""), NSLocalizedString("partyTwo", comment: ""), NSLocalizedString("partyThree", comment: ""), NSLocalizedString("partyFour", comment: ""), NSLocalizedString("partyFive", comment: ""), NSLocalizedString("partySix", comment: ""), NSLocalizedString("partySeven", comment: ""), NSLocalizedString("partyEight", comment: "")]
    case NSLocalizedString("Custom", comment: ""):
      return []
    default:
      return []
    }
    
  }
}
