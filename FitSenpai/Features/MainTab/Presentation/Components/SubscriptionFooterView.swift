//
//  SubscriptionFooterView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct SubscriptionFooterView: View {
    
    let onTermsTap: () -> Void
    let onRestoreTap: () -> Void
    let onPrivacyTap: () -> Void
    
    var body: some View {
        HStack(spacing: 62) {
            Button("Terms", action: onTermsTap)
            
            Button("Already Paid?", action: onRestoreTap)
                .foregroundStyle(.black)
            
            Button("Privacy", action: onPrivacyTap)
        }
        .foregroundColor(.gray)
        .font(.body14)
    }
}
