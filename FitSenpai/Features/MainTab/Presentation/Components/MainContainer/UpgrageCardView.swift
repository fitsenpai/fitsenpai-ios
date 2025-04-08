//
//  UpgrageCardView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct UpgrageCardView: View {
    let onUpdateWeight: () -> Void
    
    var body: some View {
        FSCard(backgroundColor: .fsSecondary.opacity(0.7)) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        FSText(text: "Upgrade to Pro!", fontStyle: .bodyBold14, color: .fsAccentForeground)
                        
                        Image(.iconCrownGreen)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.fsAccentForeground)
                    }
                    
                    FSText(text: "Unlock all workouts and meals \nfor the entire week.", fontStyle: .body12, color: .black.opacity(0.5))
                }
                
                Spacer()
                FSButton(title: "Try for $0", fontStyle: .bodyBold12, letterSpace: 0, cornerRadius: 20, size: .sm, tapAction: onUpdateWeight)
                    .frame(width: 100)
            }
            .padding(4)
        }
        .padding(.horizontal, 24)
    }
}
