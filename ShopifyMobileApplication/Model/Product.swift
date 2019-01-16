//
//  Product.swift
//  ShopifyMobileApplication
//
//  Created by Tom  Bahen on 2019-01-13.
//  Copyright © 2019 Tom  Bahen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product {
    var title: String?
    var id : Int?
    var variants: [Variant]?
    var body: String?
    var vendor: String?
    var productType: String?
    var totalInventory: Int {
        get {
            var subTotal = 0
            for variant in variants ?? [] {
                subTotal += variant.inventory ?? 0
            }
            return subTotal
        }
    }
    
    
    init(data: JSON){
        title = data["title"].stringValue
        id = data["id"].intValue
        body = data["body_html"].stringValue
        vendor = data["vendor"].stringValue
        productType = data["product_type"].stringValue
        for newVariant in data["variants"].arrayValue{
            variants?.append(Variant.init(data: newVariant))
        }
    }
}
