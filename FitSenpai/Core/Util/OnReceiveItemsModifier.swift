//
//  OnReceiveItemsModifier.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/20/25.
//

import SwiftUI
import Combine

struct OnReceiveItemsModifier: ViewModifier {
    let items: [GroceryItem]
    let onChange: (GroceryItem) -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            for item in items {
                item.objectWillChange
                    .sink { _ in
                        DispatchQueue.main.async {
                            onChange(item)
                        }
                    }
                    .store(in: &subscriptions)
            }
        }
    }

    @State private var subscriptions: Set<AnyCancellable> = []
}
