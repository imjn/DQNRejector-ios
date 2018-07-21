//
//  OnboardingViewController.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseFirestore

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let address =  UserDefaults.standard.string(forKey: "address") else {
            
            requestUID(UrlStr: "https://us-central1-eth-hack.cloudfunctions.net/CreateUser") { (uid) in
                if let uid = uid {
                    
                    self.requestUserData(UrlStr: "", uid: uid, completion: { (address, name) in
                        if let address = address, let name = name {
                            
                            UserDefaults.standard.set(address, forKey: "address")
                            UserDefaults.standard.set(name, forKey: "name")
                            
                            self.checkAdmin(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/IsServiceProvider", address: address)
                            
                        }
                    })
                    
                } else {
                    
                }
            }
            
            return
            
        }
        
        
        self.checkAdmin(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/IsServiceProvider", address: address)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAdmin(UrlStr: String, address: String) {
        
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
            
            if let resultData = try? JSONDecoder().decode(CheckAdmin.self, from: json!)
            {
                
                if resultData.result {
                    
                    self.performSegue(withIdentifier: "ToAdmin", sender: nil)
                    
                } else {
                    
                    self.performSegue(withIdentifier: "ToUser", sender: nil)
                    
                }
                
            }
                            
            print("oooooooops error")
            debugPrint(response)
        }
        
    }
    
    func requestUID(UrlStr: String, completion: @escaping (String?) -> Void) {
        
        let url = UrlStr
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url,
                          method: .post,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            
            let json = response.data
            
            if let resultData = try? JSONDecoder().decode(DQNString.self, from: json!)
            {
                
                let uid = resultData.result
                completion(uid)
                
            } else {
                completion(nil)
            }
                            
            print("oooooooops error")
            debugPrint(response)
        }
        
    }
    
    func requestUserData(UrlStr: String, uid: String, completion: @escaping (String?, String?) -> Void) {
        
        let url = UrlStr
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters = [
        
            "userid" : uid
        
        ]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            
            let json = response.data
            
            if let resultData = try? JSONDecoder().decode(DQNUser.self, from: json!)
            {
                
                let address = resultData.address
                let name = resultData.name
                completion(address, name)
                
            } else {
                completion(nil, nil)
            }
            
            print("oooooooops error")
            debugPrint(response)
        }
        
    }
    
}
