//
//  Variant.swift
//  ShopifyMobileApplication
//
//  Created by Tom  Bahen on 2019-01-13.
//  Copyright © 2019 Tom  Bahen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Variant {
    var title: String?
    var price: String?
    var inventory: Int?
    var weight: String?
    var weightUnit: String?
    
    init(data: JSON){
        title = data["title"].stringValue
        price = data["price"].stringValue
        inventory = data["inventory_quantity"].intValue
        weight = data["weight"].stringValue
        weightUnit = data["weight_unit"].stringValue
    }
}
