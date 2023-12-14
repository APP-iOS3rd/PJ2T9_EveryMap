//
//  ColorLiterals.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/14.
//

import Foundation
import UIKit

extension UIColor {
    static var b1: UIColor {
        return UIColor(hex: "2A99FF")
    }
    
    static var g1: UIColor {
        return UIColor(hex: "EFEFEF")
    }
    
    static var g2: UIColor {
        return UIColor(hex: "DDDDDD")
    }
    
    static var g3: UIColor {
        return UIColor(hex: "A4A4A4")
    }
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
