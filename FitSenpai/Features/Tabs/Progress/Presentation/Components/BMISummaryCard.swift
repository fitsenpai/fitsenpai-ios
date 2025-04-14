//
//  BMISummaryCard.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct BMISummaryCard: View {
    let bmiValue: Double
    let bmiCategory: BMICategory
    let onInfoTap: () -> Void
    
    var body: some View {
        FSCard(borderColor: Color.gray.opacity(0.2)) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FSText(text: "Your BMI", fontStyle: .bodyBold20)
                    Spacer()
                    Button(action: onInfoTap) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom) {
                        Text(String(format: "%.1f", bmiValue))
                            .font(.bodyBold24)
                        
                        
                        Text("Your weight is")
                            .font(.body12)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                        
                        BMICategoryPill(category: bmiCategory)
                    }
                    
                }
                
                BMIScaleView(bmiValue: bmiValue)
            }
            .padding(12)
        }
    }
}
