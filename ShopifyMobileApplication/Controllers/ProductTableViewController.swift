//
//  ProductTableViewController.swift
//  ShopifyMobileApplication
//
//  Created by Tom  Bahen on 2019-01-13.
//  Copyright © 2019 Tom  Bahen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import PromiseKit

class ProductTableViewController: UITableViewController {
    
    var collection: CustomCollection?
    var productIDs = [Int]()
    
    let collectionURL = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
    let productBaseURL = "https://shopicruit.myshopify.com/admin/products.json?ids="
    let accessToken = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let defaultHeaders: [String : String] = ["Content-Type":"application/json;charset=utf-8", "Accept": "application/json"]
    let segueIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            getCollection()
        
        }
       
      
        
        
    func getCollection() {
        let completeURL = collectionURL+"\(collection?.id ?? 0)"+accessToken
        

        Alamofire.request(completeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: defaultHeaders).responseData().done { response -> Void in
        
                let json = try JSON(data: response.data)
                for product in json["collects"].arrayValue {
                    self.productIDs.append(product["product_id"].intValue)
                }
            //now we can get the full product information and Collection Image if needed
            if(self.collection?.products == nil){
            self.getProducts()
            }
            if(self.collection?.picture == nil){
            self.getCollectionImage()
            }
            self.tableView.reloadData()
            }.catch {error in
                print("Error: \(error)")
        }
        
    }
    
    func getCollectionImage() {
        let completeURL = collection!.pictureURL
        
        Alamofire.request(completeURL ?? "").responseImage { response in
           self.collection?.picture = response.result.value
           self.tableView.reloadData()
        }
        
    }
    
    func getProducts() {
        //generate full URL with ALL product queries
        var completeURL = productBaseURL
        for id in productIDs {
            completeURL.append("\(id),")
        }
        completeURL = String(completeURL.dropLast())
        completeURL.append(accessToken)
        Alamofire.request(completeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: defaultHeaders).responseData().done { response -> Void in
            
            let json = try JSON(data: response.data)

            self.collection?.products = [Product]()
            for productJSON in json["products"].arrayValue {
               let newProduct = Product(data: productJSON)
                newProduct.variants = [Variant]()
                for variantJSON in productJSON["variants"].arrayValue{
                    newProduct.variants?.append(Variant(data: variantJSON))
                }
               self.collection?.products?.append(newProduct)
            }
          
            self.tableView.reloadData()
            }.catch {error in
                print("Error: \(error)")
        }
        
    }
    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collection?.products?.count ?? 0 + 1 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
         let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCollection", for: indexPath) as! ProductCollectionTableViewCell
            cell.collectionTitle.text = collection?.title
            cell.collectionBody.text = collection?.body
            cell.collectionImage.image = collection?.picture
            
            //make the picture into a circle for fun
            cell.collectionImage.layer.cornerRadius = cell.collectionImage.frame.size.width/2
            cell.collectionImage.clipsToBounds = true
            return cell
        }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as! ProductTableViewCell
        cell.productTitle.text = collection?.products?[indexPath.row].title
        cell.productBody.text = collection?.products?[indexPath.row].body
        cell.totalInventory.text = "Total Inventory: \(collection?.products?[indexPath.row].totalInventory ?? 0)"
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if segue!.identifier == segueIdentifier {
            let destination = segue!.destination as! VariantTableViewController
            let productIndex = tableView.indexPathForSelectedRow?.row
            destination.product = collection?.products?[productIndex!]
        }
    }
 

  

}
