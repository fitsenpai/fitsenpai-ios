//
//  SubscriptionInfoRow.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct SubscriptionInfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(icon)
                .font(.system(size: 24))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyBold18)
                Text(description)
                    .font(.body12)
                    .foregroundColor(.fsSubtitleColor)
            }
        }
    }
}
