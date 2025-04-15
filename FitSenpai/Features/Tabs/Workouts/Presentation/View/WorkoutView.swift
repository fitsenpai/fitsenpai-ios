//
//  WorkoutView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct WorkoutView: View {
    var image: String
    var title: String
    var videoURL: URL?
    var showInfo: Bool // Whether to show the info
    @State var isSelected: Bool
    @State private var isLoading = true // Track loading state
    
    var horizontalInfoView: some View  {
        HStack(spacing: 10) {
            IconLabelView(fsMetric: .WorkoutSet, value: 4, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutRep, value: 12, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutTime, value: 10, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            videoPreview
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    FSTextView(title, typography: .p_ui_medium, lineLimit: 1)
                    if showInfo {
                        horizontalInfoView
                    }
                }
                Spacer()
                checkBoxButton
            }
            .padding(.horizontal, 12)
        }
        .background(.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
    
    var videoPreview: some View {
        ZStack {
            if let videoURL = videoURL {
                VideoPreviewView(videoURL: videoURL, isLoading: $isLoading) // Pass loading state to VideoPreviewView
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var checkBoxButton: some View {
        Button(action: {
            isSelected.toggle()
            triggerHaptics()
        }, label: {
            if isSelected {
                Image("ic_checkbox_selected")
                    .resizable()
                    .frame(width: 29, height: 29)
            } else {
                Image("ic_checkbox_unselected")
                    .resizable()
                    .frame(width: 26, height: 26)
            }
        })
    }
    
}

#Preview {
    WorkoutView(image: "ic_workout", title: "Bench press", showInfo: true, isSelected: false)
}
