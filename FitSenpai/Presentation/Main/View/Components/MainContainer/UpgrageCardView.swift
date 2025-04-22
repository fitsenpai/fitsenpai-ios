//
//  UpgrageCardView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

struct UpgrageCardView: View {
    let onUpgradeTap: () -> Void
    
    var body: some View {
        FSCard(backgroundColor: .fsSecondary.opacity(0.7)) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 10) {
                        FSText(text: "Upgrade to Pro!", fontStyle: .bodyBold14, color: .fsAccentForeground)
                        
                        Image(.iconCrownGreen)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.fsAccentForeground)
                    }
    
                    FSText(text: "Unlock all workouts and meals \nfor the entire week.", fontStyle: .medium11, color: .fsMutedForeground, lineSpacing: 3)
                }
                
                Spacer()
                FSButton(title: "Try for $0", fontStyle: .bodyBold12, letterSpace: 0, cornerRadius: 20, size: .sm, tapAction: onUpgradeTap)
                    .frame(width: 100)
            }
            .padding(4)
        }
    }
}
