//
//  WorkoutDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI
import AVKit
import SuperwallKit

struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutDetailViewModel
    
    @State private var player = AVPlayer(url: URL(string: UserDefaults.standard.string(forKey: "videoURL") ?? "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/abdominals/seated_floor_crunches.mp4?")!)
    
    @AppState(\.isLimited) private var isLimitedAccess: Bool
   
    var body: some View {
        VStack(spacing: 12) {
            headerSection
            ScrollView {
                VStack(spacing: 20) {
                    workoutSection
                    VStack(spacing: 16) {
                        PlayerView(player: $player)
                            .frame(height: 345)
                            .onAppear() {
                                player.play()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray230, lineWidth: 1)
                            )
                            .cornerRadius(12)
                            .ignoresSafeArea()
                        
                        GenericTextListView(title: "How to perform this exercise:", instructions: viewModel.workoutSteps, isNumbered: true)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            if isLimitedAccess {
                FSButton(title: "Unlock full week", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    triggerHaptics()
                    Superwall.shared.register(placement: "campaign_trigger")
                })
            } else {
                FSButton(title: "Complete", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    dismiss()
                    triggerHaptics()
                })
            }
            
        }
      
        .padding(24)
        .background {
            Color.workoutBackgroundColor.ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            SheetIndicator()
                .padding(12)
        }
        
    }
    
    var headerSection: some View {
        HStack {
            FSTextView(viewModel.title, typography: .h4)
            Spacer()
            Image(.iconBookmark)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    if isLimitedAccess {
                        Superwall.shared.register(placement: "campaign_trigger")
                    }
                    triggerHaptics()
                }
        }
    }
    
    var targetGroupHorizontalList: some View {
        WrappedHStack(viewModel.muscleGroups, horizontalSpacing: 4, verticalSpacing: 4) { muscleGroup in
            GrayPillView(text: muscleGroup, fontStyle: .body14, cornerRadius: 24)
        }
    }
    
    var workoutInfoHorizontalView: some View {
        HStack(spacing: 8) {
            WorkoutPillView(image: "icon_chart_orange", value: 4, label: "sets")
            WorkoutPillView(image: "icon_repeat_purple", value: 12, label: "reps")
            WorkoutPillView(image: "icon_clock_green", value: 15, label: "mins")
        }
    }
    
    var workoutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            targetGroupHorizontalList
            workoutInfoHorizontalView
        }
    }
}

struct WorkoutsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutDetailViewModel(routine: Routine.initTest())
        WorkoutDetailView(viewModel: viewModel)
    }
}
