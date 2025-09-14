//
//  SaveMoneyView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct SaveMoneyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            VStack(spacing: 16) {
                FSText(text: "Your monthly expenses on fitness", fontStyle: .body16)
                    .padding(.horizontal, 24)
                
                Image(.analytics)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320)
                
                HStack {
                    FSText(text: "Month 1", fontStyle: .body12)
                    Spacer()
                    FSText(text: "Month 6", fontStyle: .body12)
                }
                .padding(.horizontal, 48)
            }
            Spacer()
            FSText(text: "Why pay more for the same results?", fontStyle: .bodyBold16, alignment: .center)
            VStack(spacing: 8) {
                HStack(spacing: 2) {
                    FSText(text: "Fit Senpai users", fontStyle: .body14, alignment: .center)
                    FSText(text: "save up to 90%", fontStyle: .bodyBold14, color: .fsAccentForeground, alignment: .center)
                    FSText(text: "compared ", fontStyle: .body14, alignment: .center)
                }
                
                FSText(text: "to traditional fitness programs.", fontStyle: .body14, alignment: .center)
            }
            Spacer()
        }
    }
}
