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

struct FlexibleSheetModifier: ViewModifier {
    var isCentered: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
            .presentationBackground(.clear)
    }
}


struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
