//
//  CustomToggle.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//


import SwiftUI

struct FSToggle: View {
    @Binding var isOn: Bool
    var leftLabel: String
    var rightLabel: String

    var body: some View {
        HStack(spacing: 32) {
            FSText(text: leftLabel, fontStyle: .bodyBold18, color: isOn ? Color.gray : Color.black)

            ZStack {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 54, height: 32)

                Circle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                    .frame(width: 16, height: 16)
                    .offset(x: isOn ? 10 : -10)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOn.toggle()
                }
            }

            FSText(text: rightLabel, fontStyle: .bodyBold18, color: isOn ? Color.black : Color.gray)
        }
    }
}
