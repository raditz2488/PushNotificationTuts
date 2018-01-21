//
//  UNService.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    override private init() {}
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func atuhorize() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No UN authorization error")
            guard granted else { return }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        let presentationOptions: UNNotificationPresentationOptions = [.alert, .sound, .badge]
        completionHandler(presentationOptions)
        
    }
}
