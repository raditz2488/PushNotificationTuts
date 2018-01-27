//
//  ProductCell.swift
//  For Sale
//
//  Created by pranav on 26/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak  var priceLabel: UILabel!
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = product.price()
    }
}
