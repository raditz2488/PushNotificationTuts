//
//  AlertService.swift
//  Remind
//
//  Created by pranav on 18/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit


class AlertService {
    private init() {}
    
    static func actionSheet(in vc: UIViewController, title: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
