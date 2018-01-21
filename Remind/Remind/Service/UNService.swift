//
//  UNService.swift
//  Remind
//
//  Created by pranav on 16/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    static let shared = UNService()
    private override init() { print("Instance created")}
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No UN auth error")
            guard granted else {
                print("User denied ACCESs")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue,
                                               title: "Run timer logic",
                                               options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
                                               title: "Run date logic",
                                               options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue,
                                               title: "Run location logic",
                                               options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue,
                                                   actions: [timerAction],
                                                   intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
                                                  actions: [dateAction],
                                                  intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue,
                                                      actions: [locationAction],
                                                      intentIdentifiers: [])
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func timerRequest(with interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Your timer is all done. Yay!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        if let attachment = notificationAttachment(for: .timer) {
            content.attachments = [attachment]
        }
        //Repeat can happen only if timeInterval is >= 60
        //Kylo Loko also says that if interval is < 60 and we set reapts to true it will crash(TBC)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.timer",
                                            content: content,
                                            trigger: trigger)
        
        unCenter.add(request)
    }
    
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Trigger"
        content.body = "It is now the future!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        if let attachment = notificationAttachment(for: .date) {
            content.attachments = [attachment]
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "You have returned"
        content.body = "Welcome back you silly coder you!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.location.rawValue
        if let attachment = notificationAttachment(for: .location) {
            content.attachments = [attachment]
        }
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
    
    func notificationAttachment(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer: imageName = "TimeAlert"
        case .date: imageName = "DateAlert"
        case .location: imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url, options: [:])
            return attachment
        } catch {
            return nil
        }
        return nil
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    //This is called when user touches the presented alert for notification, or a button on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        completionHandler()
    }
    
    //This is called when the app is in foreground and the notification is about to be shown
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN WILL present")
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
