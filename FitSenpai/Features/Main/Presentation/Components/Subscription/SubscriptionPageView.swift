//
//  SubscriptionPageView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

// MARK: - Supporting Views
struct SubscriptionPageView: View {
    let page: SubscriptionPageData
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            pageHeader
            
            if page.isPromotional {
                PromotionalContent()
            } else {
                itemsList
            }
        }
    }
    
    private var pageHeader: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(page.title)
                .font(.heading28)
                .multilineTextAlignment(.center)
            
            if let subtitle = page.subtitle {
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var itemsList: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(page.items, id: \.0) { item in
                SubscriptionInfoRow(icon: item.0, title: item.1, description: item.2)
            }
        }
    }
}
