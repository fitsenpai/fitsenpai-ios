//
//  SheetIndicator.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct SheetIndicator: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 32))
                .frame(width: 32, height: 4)
        }
        .frame(maxWidth: .infinity)
    }
}
