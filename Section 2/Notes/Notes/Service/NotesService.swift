//
//  NotesService.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation

class NotesService {
    private init() {}
    static func getNotes(completion: @escaping ([Note]) -> Void) {
        CKService.shared.query(recordTYpe: Note.recordType) { (records) in
            var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else { continue }
                notes.append(note)
            }
            completion(notes)
        }
        
    }
}
