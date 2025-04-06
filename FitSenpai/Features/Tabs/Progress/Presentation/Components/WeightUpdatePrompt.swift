//
//  WeightUpdatePrompt.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct WeightUpdatePrompt: View {
    let onUpdateWeight: () -> Void
    
    var body: some View {
        FSCard(backgroundColor: .fsSecondary.opacity(0.7)) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        FSText(text: "Keep going!", fontStyle: .bodyBold14, color: .fsAccentForeground)
                        
                        Image(.iconSparkle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.fsAccentForeground)
                    }
                    
                    FSText(text: "Tracking your weight helps\nyou see real progress.", fontStyle: .medium12, color: .black.opacity(0.5))
                }
                
                Spacer()
                FSButton(title: "Update weight", fontStyle: .bodyBold12, letterSpace: 0, cornerRadius: 20, size: .sm, tapAction: onUpdateWeight)
                    .frame(width: 124)
            }
            .padding(4)
        }
    }
}
