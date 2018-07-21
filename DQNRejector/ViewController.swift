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

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var audioPlayerInstance : AVAudioPlayer! = nil
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.Amin()
        
        requestDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/EthCall", address: "0xc633c8d9e80a5e10bb939812b548b821554c49a6")
        
        
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
            let controller = segue.destination
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        default:
            return
        }
    }
    
    @IBAction func toCamera(_ sender: Any) {
        performSegue(withIdentifier: "ToCamera", sender: nil)
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        
        requestDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/EthCall", address: "0xc633c8d9e80a5e10bb939812b548b821554c49a6")
        
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
                    
                    if let pointNum = Int(resultData.result) {
                        
                        if pointNum > 8 {
                            self.audioPlayerInstance.play()
                        }
                        
                    }
                    
                    
                }

                print("oooooooops error")
                debugPrint(response)
        }
        
    }
}

