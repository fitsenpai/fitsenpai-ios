//
//  BottomSheetPresentor.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/13/24.
//

import Foundation
import UIKit
import SwiftUI

class BottomSheetPresentor {
    private static let sharedPresentor = BottomSheetPresentor()
    private var isBottomSheetPresented = false {
        didSet {
            if !isBottomSheetPresented {
                bottomSheet?.dismissBottomSheet()
            }
        }
    }
    private var bottomSheet: BottomSheetHostingController<BottomSheetView<AnyView>>?
    
    class func shared() -> BottomSheetPresentor {
        return sharedPresentor
    }
    
    func presentWith(view: some View, buttonConfig: FSActionButtonConfig? = nil){
        guard let parentVC = DisplayUtil.getUIApplicationRootViewController() else {
            return
        }
        isBottomSheetPresented = true
                
        // Create a Binding for `isBottomSheetPresented` to pass to the SwiftUI view
        let isPresentedBinding = Binding<Bool>(
            get: { self.isBottomSheetPresented },
            set: { self.isBottomSheetPresented = $0 }
        )
        let bottomSheetContent = BottomSheetView(isPresented: isPresentedBinding, buttonConfig: buttonConfig) {
            AnyView(view)
        }
        bottomSheet = BottomSheetHostingController(rootView: bottomSheetContent, isPresented: .constant(isBottomSheetPresented))
        bottomSheet?.modalTransitionStyle = .crossDissolve
        bottomSheet?.modalPresentationStyle = .overFullScreen
        bottomSheet?.showBottomSheet(in: parentVC)
    }

}
