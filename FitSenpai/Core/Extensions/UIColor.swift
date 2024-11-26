//
//  UIColor.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init( hexString: String) {
        var hex = hexString
        var alpha: Float = 100
        let hexLength = hex.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
//            log.verbose("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#GGRRBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        if hexLength == 9 {
            // Note: this uses String subscripts as given below
            if let value = Float(hex[7...8]) {
                alpha = value
            }
            else {
                alpha = 1
            }
            hex = hex[0...6]
        }
        
        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s: Scanner = Scanner(string: hex)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt32(&rgb)
        
        // Creating the UIColor from hex int
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha / 100)
        )
    }
}

extension String {
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }
}
