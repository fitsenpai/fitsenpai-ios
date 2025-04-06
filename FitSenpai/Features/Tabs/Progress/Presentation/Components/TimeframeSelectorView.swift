//
//  TimeframeSelectorView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct TimeframeSelectorView: View {
    @Binding var selectedTimeframe: ProgressTimeframe
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProgressTimeframe.allCases, id: \.self) { timeframe in
                Button {
                    selectedTimeframe = timeframe
                } label: {
                    FSText(
                        text: timeframe.displayText,
                        fontStyle: .bodyBold12,
                        color: selectedTimeframe == timeframe ? .primary : .secondary
                    )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                    .background(selectedTimeframe == timeframe ? .white : .gray230)
                    .cornerRadius(5)
                    .padding(3)
                }
                
            }
        }
        .background(Color.gray230)
        .cornerRadius(5)
    }
}
