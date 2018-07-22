//
//  DQNsViewController.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/22.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseFirestore

class DQNsViewController: UIViewController, UITableViewDelegate {
    
    var users = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        titleView.Amin()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "DQNTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DQNCell")
        
        if let address = UserDefaults.standard.string(forKey: "address") {
            getPlace(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/ProviderOf", address: address)
        }
        
        getGuests()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGuests() {
        
        let db = Firestore.firestore()
        db.collection("Places").document("Mt.Fuji").collection("Guest").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.users.append(document.data() as NSDictionary)
                }
                
                self.tableView.reloadData()
                
            }
        }
        
    }
    func getPlace(UrlStr: String, address: String) {
        
        let url = UrlStr
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "address": address
        ]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            
                            let json = response.data
                            
                            if let resultData = try? JSONDecoder().decode(Balance.self, from: json!)
                            {
                                self.placeLabel.text = resultData.result
                                
                            } else {
                                print("oooooooops error")
                            }
                            
                            
                            debugPrint(response)
        }
        
    }
    
}

extension DQNsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DQNCell") as! DQNTableViewCell
        let user = users[indexPath.row]
        
        let name = user["name"] as! String
        let address = user["address"] as! String
        
        cell.nameLabel.text = name
        
        return cell
        
    }
}
