//
//  Modifiers.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

import SwiftUI

struct LoadingListenerModifier: ViewModifier {
    
    @Binding var viewState: ViewState
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if viewState == .loading {
                LoadingView()
            }
        }
    }
}
