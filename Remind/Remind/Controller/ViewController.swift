//
//  ViewController.swift
//  Remind
//
//  Created by pranav on 15/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNService.shared.authorize()
        CLService.shared.authorize()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterRegion),
                                               name: NSNotification.Name("InternalNotification.enteredRegion"),
                                               object: nil)
    }

    @IBAction func onTimerTapped() {
        print("Timer")
        AlertService.actionSheet(in: self, title: "5 seconds") {
            UNService.shared.timerRequest(with: 5)
        }
        
    }
    
    @IBAction func onDateTapped() {
        print("Date")
        AlertService.actionSheet(in: self, title: "Some future time") {
            var components = DateComponents()
            components.second = 0
            
            UNService.shared.dateRequest(with: components)
        }
    }
    
    @IBAction func onLocationTapped() {
        print("Location")
        AlertService.actionSheet(in: self, title: "When I return") {
            CLService.shared.updatedLocation() 
        }
    }
    
    @objc
    func didEnterRegion() {
        UNService.shared.locationRequest()
    }
}

