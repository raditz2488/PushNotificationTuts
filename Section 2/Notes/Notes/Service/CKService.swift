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
}
