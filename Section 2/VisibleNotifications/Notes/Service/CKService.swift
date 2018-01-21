//
//  CKService.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation
import CloudKit

class CKService {
    private init() {}
    static let shared = CKService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "No CK save error")
            print(record ?? "No CK record saved")
        }
    }
    
    func query(recordTYpe: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordTYpe, predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "No CKQuery error")
            guard let records = records else { return }
            DispatchQueue.main.async {
                completion(records)
            }
        }
        
    }
    
    func subscribe() {
        let subscription = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No CKSub error")
            print(sub ?? "Unable to subscribe")
        }
    }
    
    func subscribeWithUI() {
        let subscription = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "I bet ya didnt know about the power of the cloud"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No CKSub error")
            print(sub ?? "Unable to subscribe")
        }
    }
    
    func fetchRecord(with recordID: CKRecordID) {
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            print(error ?? "No CKFetch error")
            guard let record = record else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"),
                                                object: record)
            }
            
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification, let recordID = queryNotification.recordID else { return }
            fetchRecord(with: recordID)
        default: return
        }
    }
}
