//
//  ViewController.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.Amin()
        
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
}

