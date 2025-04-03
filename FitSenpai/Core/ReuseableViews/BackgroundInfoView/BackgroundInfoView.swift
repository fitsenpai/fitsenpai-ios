//
//  BackgroundInfoView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/17/24.
//
import SwiftUI

struct BackgroundInfoView: View {
    let viewModel: BackgroundInfoViewModel
    
    // MARK: - Icon View
    private var icon: some View {
        Image(viewModel.iconName)
            .resizable()
            .foregroundColor(viewModel.iconTint)
            .frame(width: 16, height: 16)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.fsSecondary)
                    .frame(width: 32, height: 32)
            }
    }
    
    // MARK: - Header View
    private var header: some View {
        VStack(spacing: 12) {
            icon
            FSText(
                text: viewModel.title,
                fontStyle: .headers20,
                color: .fsTitle,
                lineSpacing: 4,
                alignment: .center
            )
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            header
            FSText(
                text: viewModel.mainLabel,
                fontStyle: .body14,
                color: .fsSubtitleColor,
                lineSpacing: 4,
                alignment: .center
            )
            .padding(.bottom, 12)
            
            FSButton(title: viewModel.buttonLabel, tapAction: viewModel.buttonAction)
        }
        .padding(16)
        .roundedBorder(cornerRadius: 8, lineWidth: 1, borderColor: Color.gray230)
    }
}

#Preview {
    BackgroundInfoView(viewModel: .defaultConfig)
}
