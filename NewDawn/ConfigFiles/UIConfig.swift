//
//  ColorTemplate.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// This struct contains all the global properties to configure UI scheme
/// in the app
struct UIConfig {

  // MARK: - COLORS
  static let darkGreen = UIColor(red: 41.0/255.0, green: 178.0/255.0, blue: 159.0/255.0, alpha: 1)
  static let ultraDarkGreen = UIColor(red: 97.0/255.0, green: 140.0/255.0, blue: 134.0/255.0, alpha: 1)
  static let lightGreen = UIColor(red: 49.0/255.0, green: 212.0/255.0, blue: 202.0/255.0, alpha: 1)
  static let neutralGreen = #colorLiteral(red: 0.2588235294, green: 0.8039215686, blue: 0.768627451, alpha: 1)
  static let blueGray = UIColor(red: 108.0/255.0, green: 123.0/255.0, blue: 138.0/255.0, alpha: 1)

  // MARK: - TAB BAR ICONS

  static let profilIcon = "Profil"
  static let challengesIcon = "challenges"
  static let crisisIcon = "crisis"
  static let historyIcon = "history"
  static let medicIcon = "oscult"

  // MARK: - FONTS

  static let lightFont = "TitilliumWeb-Light"
  static let boldFont = "TitilliumWeb-Bold"
  static let semiBoldFont = "TitilliumWeb-SemiBold"

  // MARK: - OBJECTIVES THUMBNAILS
  static let driveThumbnail = "conduire"
  static let walkThumbnail = "marcher"
  static let partyThumbnail = "sortir"
  static let transportThumbnail = "transports"
  static let travelThumbnail = "voyager"

  // MARK: - CRISIS TIMER DISPLAY SETUP
  static let timerFormat = "%02d:%02d"

  // MARK: - CHART DISPLAY SETUP
  static let chartDateFormat = DateFormat.day
}

enum DateFormat: String {
  case hourMinute = "HH:mm"
  case day = "dd/MM"
  case dayHourMinute = "MM/dd/yyyy hh:mm a"
  case sortingFormat = "yyyy-MM-dd"
  
}
