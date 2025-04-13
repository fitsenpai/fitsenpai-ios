//
//  FSNavBarView.swift
//  FitSenpai
//
//  Created by Kevin M on 2/10/25.
//

import SwiftUI

struct FSNavBarView: View {
    @State private var navDestination: SettingsNavigation?
    
    var body: some View {
        NavigationStack {
            HStack {
                Image(.logoFsBlack)
                    .resizable()
                    .frame(width: 150, height: 20)
                Spacer()
                Button {
                    navDestination = .settings
                } label: {
                    Image(.iconGear)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .navigationDestination(item: $navDestination) { destination in
                switch destination {
                case .settings:
                    SettingsMainView()
                }
            }
        }
        
    }
}

#Preview {
    FSNavBarView()
}
