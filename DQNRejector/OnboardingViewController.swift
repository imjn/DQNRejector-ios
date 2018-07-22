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
import TapticEngine

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.viewWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.viewWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        firstFunctions()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            firstFunctions()
        }
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
            print(response.debugDescription)
            
            if let decodedData = try? JSONDecoder().decode(DQNString.self, from: json!)
            {
                
                
                
                if decodedData.result == "true" {
                    
                    self.performSegue(withIdentifier: "ToAdmin", sender: nil)
                    
                } else {
                    
                    self.performSegue(withIdentifier: "ToUser", sender: nil)
                    
                }
                
            } else {
                print("oooooooops error fuckkkkkkkkkkkkk")
            }
                            
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
        
        print("こんにちは\(uid)")
        
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
                
                print(name)
                
                completion(address, name)
                
            } else {
                completion(nil, nil)
            }
            
            debugPrint(response)
        }
        
    }
    
    func requestLoginUrl(UrlStr: String, uid: String) {
        
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
                            
                            if let result = try? JSONDecoder().decode(DQNString.self, from: json!)
                            {
                                
                                if let url = URL(string: result.result) {
                                    TapticEngine.notification.feedback(.success)
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                                else {
                                    print("failed to get the uPort url from QR code 2")
                                }
                                
                            }
                            
                            debugPrint(response)
        }
        
    }
    
    func firstFunctions() {
        guard let uid =  UserDefaults.standard.string(forKey: "uid") else {
            
            requestUID(UrlStr: "https://us-central1-eth-hack.cloudfunctions.net/CreateUser") { (uid) in
                if let uid = uid {
                    
                    UserDefaults.standard.set(uid, forKey: "uid")
                    
                    self.requestLoginUrl(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/GetLoginUrl", uid: uid)
                    
                    self.requestUserData(UrlStr: "https://us-central1-eth-hack.cloudfunctions.net/GetUserData", uid: uid, completion: { (address, name) in
                        if let address = address, let name = name {
                            
                            print(name)
                            
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
        
        if let address = UserDefaults.standard.string(forKey: "address") {
            
            self.checkAdmin(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/IsServiceProvider", address: address)
            
        } else {
            
            self.requestUserData(UrlStr: "https://us-central1-eth-hack.cloudfunctions.net/GetUserData", uid: uid, completion: { (address, name) in
                if let address = address, let name = name {
                    
                    UserDefaults.standard.set(address, forKey: "address")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    self.checkAdmin(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/IsServiceProvider", address: address)
                    
                }
            })
        }
    }
    
    
}
