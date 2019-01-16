//
//  Collection.swift
//  ShopifyMobileApplication
//
//  Created by Tom  Bahen on 2019-01-12.
//  Copyright © 2019 Tom  Bahen. All rights reserved.
//

import Foundation
import SwiftyJSON


class CustomCollection {
    var title: String?
    var id: Int?
    var pictureURL: String?
    var picture: UIImage?
    var body: String?
    var products: [Product]?
    
    
    init(data: JSON){
        id = data["id"].intValue
        title = data["title"].stringValue
        body = data["body_html"].stringValue
        //only download picture when nessecary
        pictureURL = data["image"]["src"].stringValue
    }
    
}
