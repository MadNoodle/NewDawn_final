///**
/**
NewDawn
Created by: Mathieu Janneau on 04/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import CoreData
import UserNotifications

/**
 Handles all functionnlities for Notifications
 */
struct NotificationService {
  
  static let center = UNUserNotificationCenter.current()
  
  // configuration for User Notification center
  static func setupNotificationCenter() {
    // Request user authorization
    center.requestAuthorization(
    options: [.alert, .sound]) { (authorization: Bool, error: Error?) in
      if !authorization { print("why") }
      if error != nil { print(error!) }
    }
  
    // Add an action to the notification to confirm user has taken is pill
    let challengeAction = UNNotificationAction(identifier: "actionId",
                                          title: "Go",
                                          options: [])
    // Sets the category
    let category = UNNotificationCategory(identifier: "CHALLENGE_ALARM",
                                          actions: [challengeAction],
                                          intentIdentifiers: [],
                                          options: [])
    // Tells the center to load the category notifications
    center.setNotificationCategories([category])
  }
  
  //  send notification to the center
  private static func addNotification(_ request: UNNotificationRequest) {
    // purge Notification center's stack and add new notifications
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error: Error?) in
      if let error = error {
        print("erreur:\(error.localizedDescription)")
      }
    })
  }
  
  // Remove Notification from center
  static func removeNotification(_ identifier: String) {
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
  }
  
  // Get Notification from center
  private static func getNotifications() -> [String]{
    var notifications: [String] = []
    center.getPendingNotificationRequests(completionHandler: { requests in
      for request in requests {
        notifications.append(request.identifier)
      }
    })
    return notifications
  }
  
  // Sets the content of the notification alert that pops in Home
  private static func setContent(_ content: UNMutableNotificationContent, challenge: String) {
    content.title = "it's Challenge Time"
    content.body = "here is your challenge: \(challenge)"
    content.sound = UNNotificationSound.default()
    content.categoryIdentifier = "CHALLENGE_ALARM"
  }
  
  // Create a notification
  static func scheduleNotification(_ identifier: String,
                                   to date: Date,
                                   challenge: String) {
    
    // Sets Date to the users timezone
    var calendar = Calendar.current
    
    calendar.timeZone = .autoupdatingCurrent
    
    let componentsFromDate = calendar.dateComponents([.hour, .minute, .day, .month,.year], from: date)
    // trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: componentsFromDate, repeats: false)
    print(trigger)
    // Content
    let content = UNMutableNotificationContent()
    setContent(content, challenge: challenge)
    // request
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    addNotification(request)
    print("notif: \(date)")
    
  }
  
  
}
