//
//  WeightUpdatePrompt.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct WeightUpdatePrompt: View {
    var title: String
    var subtitle: String
    var icon: ImageResource
    var buttonText: String
    let onButtonTap: () -> Void
    
    var body: some View {
        FSCard(backgroundColor: .fsSecondary.opacity(0.7)) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        FSText(text: title, fontStyle: .bodyBold14, color: .fsAccentForeground)
                        
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.fsAccentForeground)
                    }
                    
                    FSText(text: subtitle, fontStyle: .medium11, color: .fsMutedForeground, lineSpacing: 3)
                }
                
                Spacer()
                FSButton(title: buttonText, fontStyle: .bodyBold12, letterSpace: 0, cornerRadius: 20, size: .sm, tapAction: onButtonTap)
                    .frame(width: 124)
            }
            .padding(4)
        }
    }
}
