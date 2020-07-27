//
//  ItemPost.swift
//  ND Marketplace
//
//  Created by Rental on 12/9/19.
//  Copyright © 2019 Irish Intel. All rights reserved.
//

import Foundation
import UIKit

class PostItemController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var imageURL: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var seller: UITextField!
    @IBOutlet weak var specs: UITextField!
    @IBOutlet weak var tags: UITextField!
    
    @IBAction func post(_ sender: Any) {
        // Create the resquest to post the new item
        let item = Item.Builder()
        item.name = itemName.text ?? "defaultName"
        item.price = Int64(Int(price.text ?? "0") ?? 0)
        item.seller = seller.text ?? "seller"
        item.setDescription(details.text ?? "description")
        item.setSpecifications(specs.text ?? "specs")
        
        if ((imageURL.text ?? "nope").contains("http")) {
            item.image = imageURL.text ?? ""
        }
        
        var tagsArray = [String]()
        tagsArray.append(tags.text ?? "tag1")
        item.setTags(tagsArray)
    
        let itemsRequest = ListNewItemRequest.Builder()
        itemsRequest.item = try! item.build()

        let buildData: Data = try! itemsRequest.build().data()
        let clientConnector = ClientConnector(port: 7004)
        
        // Hangs for 2 seconds while it tries to connect and send data.
        let responseData = clientConnector.connectAndSend(data: buildData) as Data
        guard let response: Response = try? Response.Builder().mergeFrom(data: responseData).build() else {
           let alert = UIAlertController(title: "Could not load feed",
                                         message: "Something went terribly wrong when loading feed of items. Please try again.",
                                         preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
           self.present(alert, animated: true)
           return
        }
        if (response.status) {
            let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "BuyViewController"))!
            self.present(vc, animated: true, completion: nil)
            let alert = UIAlertController(title: "Success!",
                                          message: "Your item has been posted successfully!",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Coool Beans", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
