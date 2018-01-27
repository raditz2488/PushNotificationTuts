//
//  Product.swift
//  For Sale
//
//  Created by pranav on 26/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation

struct Product {
    let title: String
    let cost: Double
    
    func price() -> String {
        let costString = String(format: "%.2f",cost)
        return "$" + costString
    }
}
