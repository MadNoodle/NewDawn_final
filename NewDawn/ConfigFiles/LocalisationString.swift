///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

class LocalisationString {
  
  enum ErrorTitles: String {
    case error = "Error"
    case sorry = "Sorry"
    case cancel = "Cancel"
  }
  
  // MARK: - ONBOARDING STRINGS
  enum RegisterString: String {
    case lastNamePlaceholder = "Lastname"
    case firstNamePlaceholder = "firstName"
    case emailPlaceholder = "email"
    case passwordPlaceholder = "Enter password"
    case repeatPasswordPlaceholder = "Re-enter password"
  }
  
  enum RegisteringAlert: String {
    case differentPassword = "the two passords are differents, please retry"
  }
  
  
  
  
  
  // MARK: - VC TITLES
  
  static let profilVcTitle = "Today"
  static let challengesVcTitle = "Challenges"
  static let crisisVcTitle = "Crisis"
  static let historyVcTitle = "History"
  static let medicVcTitle = "Find a Medic"
  
  // MARK: - PROFIL STRINGS
  static let newChallengeAlert = "New Challenge"
  static let addAlert = "Add a New Challenge"
  static let messageAlert = ""
  static let rightButtonText = "add challenge"
  
  // MARK: - CHARTS
  static let noDataText = "You need to provide data for the chart."
  static let dataLabel = "number"
  
  // MARK: - MAIL COMPOSER
  
  static let messageRecipient = "mjanneau@gmail.com"
  static let messageSubject = "Sending you an in-app e-mail..."
  static let messageBody = "Sending e-mail in-app is not so bad!"
  static let mime = "application/pdf"
  static let attachmentFormat = "pdf"
  static let attachmentName = "NewDawnReport"
  
  // MARK: - ALERT MESSAGES
  static let sorry = "Sorry"
}
