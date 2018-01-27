//
//  ProductsSnapshot.swift
//  For Sale
//
//  Created by pranav on 27/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation
import Firebase

struct ProductsSnapshot {
    let products: [Product]
    
    init?(snapshot:DataSnapshot) {
        guard let snapDict = snapshot.value as? [String: [String: Any]] else { return nil }
        var products = [Product]()
        for snap in snapDict {
            guard let product = Product(valueDict: snap.value) else { continue }
            products.append(product)
        }
        self.products = products
    }
}
