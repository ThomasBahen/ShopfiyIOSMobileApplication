//
//  CollectionsTableViewController.swift
//  
//
//  Created by Tom  Bahen on 2019-01-08.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollectionsTableViewController: UITableViewController {
    
   
    var collections = [CustomCollection]()
    let collectionsURL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let segueIdentifier = "CollectionsToProducts"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(collectionsURL).response { request in
            do {
                let json = try JSON(data: request.data!)
                //Collections contain titles and "body" descrptions for user as well as id's to navigate to further data
                for collectionJSON in json["custom_collections"].arrayValue{
                    self.collections.append(CustomCollection.init(data: collectionJSON))
                }
                //AF is async, must reload data
                self.tableView.reloadData()
            } catch {
                //error thrown by the SwiftyJSON JSON initalizer
                print(error)
            }
            
        }
        
       
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCollection", for: indexPath) as? CollectionsTableViewCell
        cell?.setCollection(collection: collections[indexPath.row])
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if segue!.identifier == segueIdentifier {
            let destination = segue!.destination as! ProductTableViewController
            let collectionIndex = tableView.indexPathForSelectedRow?.row
            destination.collection = collections[collectionIndex!]
        }
    }
    
    

}
