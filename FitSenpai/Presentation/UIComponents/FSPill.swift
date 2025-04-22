//
//  FSPill.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

import SwiftUI

struct FSPill: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.body10)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.gray246)
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
}
