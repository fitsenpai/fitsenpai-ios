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
        VStack(spacing: 20) {
            FSTextView("Are you sure you want\nto log out?", typography: .p_ui_bold, alignment: .center)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 10) {
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
        .padding(24)
        .frame(maxWidth: 242)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}
