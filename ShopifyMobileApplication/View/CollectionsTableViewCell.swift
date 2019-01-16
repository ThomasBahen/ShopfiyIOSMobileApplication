//
//  CollectionsTableViewCell.swift
//  ShopifyMobileApplication
//
//  Created by Tom  Bahen on 2019-01-12.
//  Copyright © 2019 Tom  Bahen. All rights reserved.
//

import UIKit

class CollectionsTableViewCell: UITableViewCell {
    
    var collection: CustomCollection?

    func setCollection(collection: CustomCollection){
        self.collection = collection
        collectionTitle.text = collection.title
    }
    //simple Table View Cell with two fields
    @IBOutlet weak var collectionTitle: UILabel!
    

}
