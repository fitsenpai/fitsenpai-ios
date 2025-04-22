//
//  FSLoading.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/13/25.
//

import SwiftUI
import Lottie

struct FSLoading: View {
    @Binding var config: FSLoadingConfig
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            FSTextView(config.title, typography: config.typography, alignment: .center)
            
            if let subtitle = config.subtitle {
                FSTextView(subtitle, typography: .p_ui, alignment: .center)
            }
            
            LottieView(animation: .named("fs-loading"))
              .playing(loopMode: .loop)
              .frame(width: 40, height: 40)
        }
        .padding(24)
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .center)
    }
}

struct FSLoadingConfig {
    let title: String
    var subtitle: String?
    var typography: FSTypography = .h2
    
    
    static var defaultConfig: FSLoadingConfig {
        .init(title: "", subtitle: "Checking session...")
    }
}
