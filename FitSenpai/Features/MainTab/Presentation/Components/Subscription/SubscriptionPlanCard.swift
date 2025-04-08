//
//  SubscriptionPlanCard.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct SubscriptionPlanCard: View {
    let plan: PlanItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(plan.type.title)
                        .font(.bodyBold16)
                        .padding(.top, 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .bottom, spacing: 4) {
                            Text(plan.price)
                                .font(.medium14)
                          
                            if let originalPrice = plan.originalPrice {
                                Text(originalPrice)
                                    .strikethrough()
                                    .font(.body10)
                                    .foregroundColor(.red)
                                    .padding(.bottom, 2)
                            } else {
                                Text(plan.period)
                                    .font(.body12)
                                    .foregroundColor(.fsSubtitleColor)
                            }
                        }
                        
                        if !plan.subtitle.isEmpty {
                            Text(plan.subtitle)
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(width: 84, height: 74, alignment: .topLeading)
                .padding(12)
                .background(isSelected ? Color.fsAccent : Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.fsPrimary : Color.gray230, lineWidth: 2)
                )
                .padding(.top, 12)
                
                if plan.isPopular {
                    Text("MOST POPULAR")
                        .font(.medium8)
                        .foregroundColor(.black)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(isSelected ? Color.fsPrimary : Color.gray230)
                        .cornerRadius(12)
                }
            }
        }
        .accentColor(.black)
    }
}
