//
//  DynamicItemController.swift
//  ND Marketplace
//
//  Created by Rental on 12/9/19.
//  Copyright © 2019 Irish Intel. All rights reserved.
//

import Foundation
import UIKit
import SwiftProtobuf
import SocketSwift

class ItemController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemName: String = UserDefaults.standard.string(forKey: "itemName") ?? "Item Name"
        self.itemName.text = itemName
        let price: String = UserDefaults.standard.string(forKey: "price") ?? "price"
        self.price.text = price
        let details: String = UserDefaults.standard.string(forKey: "details") ?? "details"
        self.details.text = details
        let seller: String = UserDefaults.standard.string(forKey: "seller") ?? "seller"
        self.seller.text = seller
        let specs: String = UserDefaults.standard.string(forKey: "specs") ?? "specs"
        self.specs.text = specs
        
        
        let tags: [String] = UserDefaults.standard.stringArray(forKey: "tags") ?? ["tag"]
        
        self.tags.text = ""
        
        for tag in tags {
            self.tags.text?.append("\(tag), ")
        }
        
        let imagePath: String = UserDefaults.standard.string(forKey: "image") ?? "https://cdn.shopify.com/s/files/1/1245/1481/products/2_DIAMOND_BLACK_1_1024x1024.jpg?v=1531164809"
        let imageUrl = URL(string: imagePath)
        let imageData = try! Data(contentsOf: imageUrl!)
        image.image = UIImage(data: imageData)

    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var specs: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBAction func back(_ sender: Any) {
    }
    
}
