//
//  AlertService.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class AlertService {
    private init() {}
    static func composeNote(in vc: UIViewController, completion: @escaping (Note) -> Void) {
        let alert = UIAlertController(title: "New Note", message: "Whatss on your mind?", preferredStyle: .alert)
        alert.addTextField { (titleTF) in
            titleTF.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            let note = Note(title: title)
            completion(note)
        }
        alert.addAction(post)
        vc.present(alert, animated: true)
    }
}
