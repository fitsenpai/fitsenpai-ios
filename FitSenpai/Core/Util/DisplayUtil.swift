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
        // Access the active scene
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }

        // Traverse the view controller hierarchy
        if var topController = keyWindow.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }
    
}
