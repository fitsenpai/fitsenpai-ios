//
//  DisplayUtil.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/13/24.
//

import Foundation
import UIKit
import SwiftUI

func mainScreen() -> CGRect {
    return UIScreen.main.bounds
}

class DisplayUtil {
    class func getUIApplicationRootViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        
        return nil
    }
    
}
