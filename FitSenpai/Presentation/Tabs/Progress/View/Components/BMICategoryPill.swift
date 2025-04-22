//
//  BMICategoryPill.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct BMICategoryPill: View {
    let category: BMICategory
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(category.color)
                .frame(width: 8, height: 8)
            
            Text(category.rawValue.uppercased())
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
