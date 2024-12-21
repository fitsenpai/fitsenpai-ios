//
//  UIColor.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString
        var alpha: CGFloat = 1.0
        let hexLength = hex.count

        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
            self.init(white: 0, alpha: 1)
            return
        }

        if hexLength == 9 {
            // Extract alpha value if present
            if let alphaValue = Int(hex.suffix(2), radix: 16) {
                alpha = CGFloat(alphaValue) / 255.0
            } else {
                alpha = 1.0
            }
            hex = String(hex.prefix(7)) // Remove alpha part
        }

        // Parse the RGB components
        guard let rgbValue = Int(hex.dropFirst(), radix: 16) else {
            self.init(white: 0, alpha: 1)
            return
        }

        // Creating the UIColor from the RGB int
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
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
