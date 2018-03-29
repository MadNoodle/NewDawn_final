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
  
  static func getChallenges(for category: ChallengeType ) -> [String]{
    
    switch category {
    case .drive:
      return [drivingOne, drivingTwo,drivingThree ,drivingFour , drivingFive, drivingSix, drivingSeven, drivingEight]
    case .travel:
      return [drivingOne, drivingTwo,drivingThree ,drivingFour , drivingFive, drivingSix, drivingSeven, drivingEight]
    case .walk:
      return [drivingOne, drivingTwo,drivingThree ,drivingFour , drivingFive, drivingSix, drivingSeven, drivingEight]
    case .transport:
      return [drivingOne, drivingTwo,drivingThree ,drivingFour , drivingFive, drivingSix, drivingSeven, drivingEight]
    case .party:
      return [drivingOne, drivingTwo,drivingThree ,drivingFour , drivingFive, drivingSix, drivingSeven, drivingEight]
    }
    
  }
}
