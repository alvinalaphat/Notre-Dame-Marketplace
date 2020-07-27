//
//  BuyViewController.swift
//  ND Marketplace
//
//  Created by Eddie Cunningham on 12/3/19.
//  Copyright © 2019 Irish Intel. All rights reserved.
//

import Foundation
import UIKit

class BuyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var posts = [ItemPost]()
    
    func fetchItems() {
        let userId: String = "DEFAULT"
        
        // Create the resquest to get the list of items
        let itemsRequest = ItemFeedRequest.Builder()
        itemsRequest.setUser(userId)
        itemsRequest.setHeadTime("NIL")
        itemsRequest.setHeadItemId("NIL")
        let buildData: Data = try! itemsRequest.build().data()
        let clientConnector = ClientConnector(port: 7003)
        
        // Hangs for 2 seconds while it tries to connect and send data.
        let responseData = clientConnector.connectAndSend(data: buildData) as Data
        guard let response: ItemFeedResponse = try? ItemFeedResponse.Builder().mergeFrom(data: responseData).build() else {
           let alert = UIAlertController(title: "Could not load feed",
                                         message: "Something went terribly wrong when loading feed of items. Please try again.",
                                         preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
           self.present(alert, animated: true)
           return
        }
        
        if (response.item.count > 0) {
            for item in response.item.reversed() {
                let post = ItemPost()
                post.itemName = item.name
                print(item.price ?? "0.00")
                post.itemPrice = "$\(item.price ?? 0)"
                print(post.itemPrice ?? "0.00")
                post.itemImage = item.image
                post.itemDescription = item.description
                post.specs = item.specifications
                post.seller = item.seller
                post.tags = item.tags
                posts.append(post)
            }
        } else {
            let post = ItemPost()
            post.itemName = "Item Name"
            post.itemPrice = "$X.XX"
            post.itemImage = "https://miro.medium.com/max/5696/0*aLihoFygQ7NWbs58"
            posts.append(post)
            posts.append(post)
            posts.append(post)
            posts.append(post)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemFeedCell", for: indexPath) as! ItemFeedCell
        cell.itemName.text = posts[indexPath.row].itemName
        cell.itemPrice.text = posts[indexPath.row].itemPrice
        
        let imageUrl = URL(string: posts[indexPath.row].itemImage)!
        let imageData = try! Data(contentsOf: imageUrl)
        cell.itemImageButton.setBackgroundImage(UIImage(data: imageData), for: .normal)
        cell.itemImageButton.tag = indexPath.row
        cell.itemImageButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.backgroundColor = .white
        return cell
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
    }
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        UserDefaults.standard.set(posts[sender.tag].itemName, forKey: "itemName")
        UserDefaults.standard.set(posts[sender.tag].itemPrice, forKey: "price")
        
        UserDefaults.standard.set(posts[sender.tag].itemDescription, forKey: "details")
        UserDefaults.standard.set(posts[sender.tag].seller, forKey: "seller")
        UserDefaults.standard.set(posts[sender.tag].specs, forKey: "specs")
        UserDefaults.standard.set(posts[sender.tag].tags, forKey: "tags")
        UserDefaults.standard.set(posts[sender.tag].itemImage, forKey: "image")
        
        let vc : UIViewController =
        (self.storyboard?.instantiateViewController(withIdentifier: "itemController"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemFeedCell.self, forCellWithReuseIdentifier: "itemFeedCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        fetchItems()
    }
}

extension BuyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
}
