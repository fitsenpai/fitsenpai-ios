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
                FSTextView("Your Weight", typography: .h4)
                WeightChartView(data: data)
                    .frame(height: 153)
            }
            .padding(12)
        }
    }
}
