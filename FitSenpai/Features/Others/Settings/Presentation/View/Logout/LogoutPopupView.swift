//
//  LogoutPopupView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/10/25.
//

import SwiftUI

struct LogoutPopupView: View {
    @Environment(\.dismiss) private var dismiss
    var onTapGesture: () -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                Text("Are you sure you want\nto log out?")
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    Button("Cancel") {
                        withoutAnimation {
                            dismiss()
                        }
                    }
                    .font(.bodyBold14)
                    .frame(width: 100, height: 40)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.gray)
                    .cornerRadius(32)
                    
                    Button("Log out") {
                        withoutAnimation {
                            dismiss()
                        }
                        onTapGesture()
                    }
                    .font(.bodyBold14)
                    .frame(width: 100, height: 40)
                    .background(Color.fsPrimary)
                    .foregroundColor(.black)
                    .cornerRadius(32)
                }
            }
            .padding(.vertical, 24)
        }
        .frame(maxWidth: 270)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}
