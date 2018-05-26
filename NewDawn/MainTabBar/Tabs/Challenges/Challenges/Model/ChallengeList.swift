///**
/**
NewDawn
Created by: Mathieu Janneau on 28/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct ChallengeList {
  
  static let drivingOne = "Drive 1 Km with someone"
  static let drivingTwo = "Drive 2 Km with Someone"
  static let drivingThree = "Drive 1 Km alone"
  static let drivingFour = "Drive 2 Km alone"
  static let drivingFive = "Drive in traffic"
  static let drivingSix = "Drive outside the city"
  static let drivingSeven = "Drive on the highway"
  static let drivingEight = "Take a trip in car"
  
  static func getChallenges(for category: String ) -> [String] {
    
    switch category {
    case NSLocalizedString("Drive", comment: ""):
      return [drivingOne, drivingTwo, drivingThree, drivingFour, drivingFive, drivingSix, drivingSeven, drivingEight]
    case NSLocalizedString("Travel", comment: ""):
      return [drivingOne, drivingTwo, drivingThree, drivingFour, drivingFive, drivingSix, drivingSeven, drivingEight]
    case NSLocalizedString("Walk", comment: ""):
      return [drivingOne, drivingTwo, drivingThree, drivingFour, drivingFive, drivingSix, drivingSeven, drivingEight]
    case NSLocalizedString("Transportation", comment: ""):
      return [drivingOne, drivingTwo, drivingThree, drivingFour, drivingFive, drivingSix, drivingSeven, drivingEight]
    case NSLocalizedString("Party", comment: ""):
      return [drivingOne, drivingTwo, drivingThree, drivingFour, drivingFive, drivingSix, drivingSeven, drivingEight]
    case NSLocalizedString("Custom", comment: ""):
      return []
    default:
      return []
    }
    
  }
}
