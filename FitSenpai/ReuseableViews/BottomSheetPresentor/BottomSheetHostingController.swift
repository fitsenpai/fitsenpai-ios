//
//  BottomSheetHostingController.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/13/24.
//

import Foundation
import UIKit
import SwiftUI

class BottomSheetHostingController<Content: View>: UIHostingController<Content> {
    @Binding var isPresented: Bool

    init(rootView: Content, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        super.init(rootView: rootView)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func animateBackgroundColor() {
//        UIView.animate(withDuration: 0.2) {
//            self.view.backgroundColor = self.isPresented ? UIColor.black.withAlphaComponent(0.3) : UIColor.clear
//        }
    }
    
    func showBottomSheet(in parent: UIViewController) {
        isPresented = true
        parent.present(self, animated: true, completion: {
            self.animateBackgroundColor()
        })
    }
    
    func dismissBottomSheet() {
        isPresented = false
        self.dismiss(animated: true, completion: nil)
    }
}

