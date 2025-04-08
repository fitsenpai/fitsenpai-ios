//
//  PromotionalContent.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct PromotionalContent: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gift")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            HStack(spacing: 8) {
                Text("Here's a")
                Text("80% OFF")
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                Text("discount ")
            }
            
            Text("Only $3.49 / month")
                .font(.system(size: 24, weight: .bold))
            
            Text("Lowest annual plan ever")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
