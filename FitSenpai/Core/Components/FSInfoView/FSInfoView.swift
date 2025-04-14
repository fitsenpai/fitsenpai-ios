//
//  FSInfoView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI
import Lottie

struct FSInfoView: View {
    let viewModel: FSInfoViewModel
    @State private var isAnimating: Bool = false
    
    // MARK: - Icon View
    private var icon: some View {
        Image(viewModel.iconName)
            .resizable()
            .foregroundColor(viewModel.iconTint)
            .frame(width: 20, height: 20)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(viewModel.iconBackground)
                    .frame(width: 32, height: 32)
            }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if !viewModel.isLoading {
                icon
            }
            
            FSText(
                text: viewModel.title,
                fontStyle: .heading20,
                color: .fsTitle,
                lineSpacing: 1,
                alignment: .center
            )
            
            FSText(
                text: viewModel.mainLabel,
                fontStyle: .body14,
                color: .fsMutedForeground,
                lineSpacing: 8,
                alignment: .center
            )
            .padding(.bottom, 12)
            
            if viewModel.isLoading {
                LottieView(animation: .named("fs-loading"))
                  .playing(loopMode: .loop)
                  .frame(width: 40, height: 40)
            }
            
            if viewModel.showButton {
                FSButton(title: viewModel.buttonLabel, fontStyle: .bodyBold16, cornerRadius: 32, tapAction: viewModel.buttonAction)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity ,idealHeight: 320, maxHeight: viewModel.containerHeight, alignment: .center)
        .roundedBorder(cornerRadius: 8, lineWidth: 1, borderColor: viewModel.showBorder ? Color.gray230 : Color.clear)
    }
}

#Preview {
    FSInfoView(viewModel: .defaultConfig)
}
