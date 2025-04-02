//
//  FSNavBarView.swift
//  FitSenpai
//
//  Created by Kevin M on 2/10/25.
//

import SwiftUI

struct FSNavBarView: View {
    var body: some View {
        HStack {
            Image(.logoFsBlack)
                .resizable()
                .frame(width: 150, height: 20)
            Spacer()
            Image(.iconGear)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    FSNavBarView()
}
