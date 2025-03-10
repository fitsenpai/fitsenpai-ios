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
            Image("img_fs_logo")
                .resizable()
                .frame(width: 150, height: 20)
            Spacer()
            Image("img_dummy_prof_1")
                .resizable()
                .frame(width: 25, height: 25)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    FSNavBarView()
}
