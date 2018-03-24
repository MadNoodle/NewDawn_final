///**
/**
NewDawn
Created by: Mathieu Janneau on 22/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct MoodPlot {
  var date: Double
  var value: Double
  
  static func getMockData() -> [MoodPlot]{
    var data = [MoodPlot]()
   
    for i in 0..<50 {
      let random = Double(Int(arc4random_uniform(5) ))
      let mood = MoodPlot(date: Date().timeIntervalSince1970 + (86400 * Double(i)), value: random)
      data.append(mood)
    }
    return data
  }
  
  static func getChallenges() -> (Int,Int,Float){
    let percentage: Float = (5 / 10) * 100
    return (5,10,percentage)
  }
}
