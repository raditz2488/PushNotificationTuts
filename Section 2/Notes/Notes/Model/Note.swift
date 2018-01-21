//
//  Note.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation
import CloudKit

struct Note {
    var title: String
    static let recordType = "Note"
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title
    }
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
