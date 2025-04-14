//
//  FeedbackOptionView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI

struct FeedbackOptionView: View {
    let text: String
    @Binding var isSelected: String?
    
    var body: some View {
        Button(action: {
            isSelected = (isSelected == text) ? nil : text
        }) {
            Text(text)
                .font(.body14)
                .foregroundColor(isSelected == text ? Color.black : Color.black.opacity(0.4))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected == text ? Color.black : Color.black.opacity(0.2), lineWidth: 1)
                )
        }
    }
}


struct FeedbackOptionView2: View {
    let text: String
    @Binding var isSelected: String?
    
    var body: some View {
        Button(action: {
            isSelected = (isSelected == text) ? nil : text
        }) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected == text ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected == text ? Color.black : Color.gray.opacity(0.1))
                )
        }
    }
}
