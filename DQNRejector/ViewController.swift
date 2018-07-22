//
//  ViewController.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import BubbleTransition
import Alamofire
import AVFoundation
import FirebaseFirestore

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var audioPlayerInstance : AVAudioPlayer! = nil
    var currentDQN: Int? = nil
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let transition = BubbleTransition()
    var address = String()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.Amin()
        
        guard let add =  UserDefaults.standard.string(forKey: "address") else {
            
            self.dismiss(animated: true, completion: nil)
            
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        
        address = add
        
        requestDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/EthCall", address: address)
        
        
        let soundFilePath = Bundle.main.path(forResource: "failed", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = cameraBtn.center
        transition.bubbleColor = UIColor.hex(hex: "8E2DE2", alpha: 1.0)
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = cameraBtn.center
        transition.bubbleColor = UIColor.hex(hex: "8E2DE2", alpha: 1.0)
        return transition
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToCamera":
            let controller = segue.destination as! CameraViewController
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            
            controller.currentDQN = currentDQN!
            
        default:
            return
        }
    }
    
    @IBAction func toCamera(_ sender: Any) {
        
        if let dqn = currentDQN {
            performSegue(withIdentifier: "ToCamera", sender: nil)
        }
        
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        
        requestDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/EthCall", address: address)
        
    }
    
    func requestDQN(UrlStr: String, address: String) {
        
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
                    self.pointLabel.text = resultData.result
                    self.currentDQN = Int(resultData.result)!
                }

                print("oooooooops error")
                debugPrint(response)
        }
        
    }
    
    
    @objc func update(tm: Timer) {
        requestDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/EthCall", address: address)
    }
}

