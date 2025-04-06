//
//  MetricsPillView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct MetricsPillView: View {
    var image: String
    var value: Int
    var label: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(image)
                .resizable()
                .frame(width: 16, height: 16)
                .scaledToFit()
            HStack(spacing: 2) {
                Text("\(value)")
                    .font(.body16)
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: true,vertical: false)
                Text(label)
                    .font(.body14)
                    .foregroundStyle(Color.fsSubtitleColor)
                    .fixedSize(horizontal: true,vertical: false)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        }
        
    }
}

