//
//  UNService.swift
//  For Sale
//
//  Created by pranav on 27/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit
import UserNotifications

//We subclass NSObject as we want it to be delegate of UNUserNotificationCenter
class UNService: NSObject {
    private override init() {}
    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No un authorization error")
            guard granted else { return }
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func configure() {
        unCenter.delegate = self
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
