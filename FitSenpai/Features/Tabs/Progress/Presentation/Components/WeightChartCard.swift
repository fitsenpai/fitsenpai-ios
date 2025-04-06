//
//  WeightChartCard.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct WeightChartCard: View {
    let data: [WeightDataPoint]
    
    var body: some View {
        FSCard(borderColor: Color.gray.opacity(0.2)) {
            VStack(alignment: .leading, spacing: 48) {
                FSText(text: "Your Weight", fontStyle: .medium20)
                
                WeightChartView(data: data)
                    .frame(height: 140)
            }
            .padding(12)
        }
    }
}
