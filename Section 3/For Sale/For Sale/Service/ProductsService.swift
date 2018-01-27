//
//  ProductsService.swift
//  For Sale
//
//  Created by pranav on 27/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import Foundation

protocol ProductsServiceDelegate {
    func didChange(products: [Product])
}

class ProductsService {
    private init() {}
    static let shared = ProductsService()
    var delegate: ProductsServiceDelegate?
    
    func observeProducts() {
        FIRDatabaseService.shared.observe(.products) { (snapshot) in
            guard let productSnapshot = ProductsSnapshot(snapshot: snapshot) else { return }
            self.delegate?.didChange(products: productSnapshot.products)
        }
    }
    
    func post(product: Product) {
        FIRDatabaseService.shared.post(parameters: product.parameters(), to: .products)
    }
}
