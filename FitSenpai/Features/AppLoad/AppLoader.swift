//
//  AppLoader.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import Foundation
import SwiftUI

class AppLoader {
    // Singleton instance
    static let shared = AppLoader()

    private var window: UIWindow?

    // Private initializer to restrict instantiation
    private init() {}

    // Configure the window
    func configure(window: UIWindow) {
        self.window = window
    }
    
    func presentLoginViewController() {
        let view = AuthLandingView()
        let loginViewController = UIHostingController(rootView: view)
        presentRootViewController(loginViewController)
    }
    
    func presentMainViewController() {
        let view = FSTabView()
        let mainViewController = UIHostingController(rootView: view)
        presentRootViewController(mainViewController)
    }
    
    func presentRootViewController(_ controller: UIViewController) {
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Logout
    
    func logout() {
        //
    }
    
    func logoutFromServices() {
        //
    }

}

