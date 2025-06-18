//
//  View+Ext.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

import SwiftUI

extension View {
    /// Adds a loading indicator overlay based on the provided loading state.
    /// - Parameter isPresented: A binding to a Boolean value that determines whether the loading indicator is shown.
    /// - Returns: A view with the loading overlay applied.
    func loadingOverlay(state: Binding<ViewState>) -> some View {
        modifier(LoadingListenerModifier(viewState: state))
    }
    
    /// Adds a reduced white loading indicator overlay based on the provided loading state.
    /// - Parameter state: A binding to ViewState that determines whether the loading indicator is shown.
    /// - Returns: A view with the reduced white loading overlay applied.
    func reducedWhiteLoadingOverlay(state: Binding<ViewState>) -> some View {
        modifier(LoadingListenerModifier(viewState: state, loadingStyle: .reduced))
    }
    
    func flexibleSheet() -> some View {
        modifier(FlexibleSheetModifier())
    }
    
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
