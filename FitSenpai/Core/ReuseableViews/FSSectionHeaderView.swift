//
//  FSSectionHeaderView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct FSSectionHeaderView: View {
    let text: String
    var showGenerateButton: Bool = true
    @State private var feedbackType: WorkoutSheetType?
    
    var body: some View {
        HStack(spacing: 12) {
            FSText(text: text, fontStyle: .heading25, color: .fsTitle)
            Spacer()
            HStack(spacing: 15) {
                if showGenerateButton {
                    regenerateButton
                }
                feedbackButtons
            }
            .frame(height: 16)
        }
        .sheet(item: $feedbackType, content: { type in
            switch type {
            case .negative:
                NegativeFeedbackSheet(feedbackType: $feedbackType)
                    .flexibleSheet()
                    .background(.thickMaterial)
            case .positive, .negativeInput:
                NegativeFeedbackInoutSheet()
                    .flexibleSheet()
                    .background(.thickMaterial)
            case .changeWorkout:
                ChangeWorkoutSheetSheet()
                    .flexibleSheet()
                    .background(.thickMaterial)
            }
        })
        
    }
    
    private var feedbackButtons: some View {
        Group {
            Button {
                feedbackType = .negative
            } label: {
                Image("ic_thumbs_down")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Button {
                feedbackType = .positive
            } label: {
                Image("ic_thumbs_up")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private var regenerateButton: some View {
        Button {
            feedbackType = .changeWorkout
        } label: {
            Image("ic_regenerate")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
    
}
