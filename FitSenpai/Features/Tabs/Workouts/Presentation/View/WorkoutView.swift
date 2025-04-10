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
        HStack {
            IconLabelView(fsMetric: .WorkoutSet, value: 4, fontStyle: .body10, fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutRep, value: 12, fontStyle: .body10, fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutTime, value: 10, fontStyle: .body10, fontColor: .fsMutedForeground, iconSize: 12)
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            videoPreview
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10 ) {
                    FSText(text: title, fontStyle: .medium16, color: .fsTitle, lineLimit: 1)
                    if showInfo {
                        horizontalInfoView
                            .ignoresSafeArea()
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
          
            if isLoading {
                // Show a loading indicator or placeholder
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 24, height: 24)
            } else {
                Color.black.opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                // When not loading, show the play icon
                Image("ic_play")
                    .resizable()
                    .frame(width: 11, height: 13)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var checkBoxButton: some View {
        Button(action: {
            isSelected.toggle()
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
