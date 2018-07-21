//
//  DQNUI.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func Amin() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        // https://uigradients.com/#IbizaSunset
        let color1 = UIColor.hex(hex: "8E2DE2", alpha: 1.0).cgColor
        let color2 = UIColor.hex(hex: "4A00E0", alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        self.layer.insertSublayer(gradientLayer,at:0)
    }
}

extension UIColor {
    static func hex(hex: String, alpha: CGFloat?) -> UIColor {
        
        let alpha = alpha ?? 1.0
        if hex.count == 6 {
            let rawValue: Int = Int(hex, radix: 16) ?? 0
            let B255: Int = rawValue % 256
            let G255: Int = ((rawValue - B255) / 256) % 256
            let R255: Int = ((rawValue - B255) / 256 - G255) / 256
            
            let color = UIColor(red: CGFloat(R255) / 255,
                                green: CGFloat(G255) / 255,
                                blue: CGFloat(B255) / 255,
                                alpha: alpha)
            return color
            
        } else {
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
            return color
        }
    }
}
