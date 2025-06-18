//
//  WorkoutDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI
import AVKit

struct WorkoutDetailView: View {
    @EnvironmentObject private var viewModel: WorkoutsViewModel
    @EnvironmentObject private var superwall: SuperwallManager
    @Environment(\.dismiss) private var dismiss
    
    private var player: AVPlayer
    
    @Binding var routine: WorkoutRoutine
    
    init(routine: Binding<WorkoutRoutine>) {
        self._routine = routine
        let playerInstance = AVPlayer(url: routine.wrappedValue.videoURL)
        self.player = playerInstance
    }
       
    var body: some View {
        VStack(spacing: 12) {
            headerSection
            ScrollView {
                VStack(spacing: 20) {
                    workoutSection
                    VStack(spacing: 16) {
                        PlayerView(player: .constant(player))
                            .frame(height: 345)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray230, lineWidth: 1)
                            )
                            .cornerRadius(12)
                            .ignoresSafeArea(.all, edges: .horizontal)
                            .onAppear {
                                player.play()
                            }
                        
                        GenericTextListView(title: "How to perform this exercise:", instructions: routine.instructions, isNumbered: true)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 24)
            
            if superwall.isFirstDayTrialActive {
                FSButton(title: "Unlock full week", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    triggerHaptics()
                    superwall.presentPaywall(for: .proContent)
                })
            } else if !routine.isCompleted {
                FSButton(title: "Complete", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    routine.isCompleted = true
                    viewModel.updateDailyProgress()
                    viewModel.objectWillChange.send()
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
        .onDisappear {
            player.pause()
        }
    }
    
    var headerSection: some View {
        HStack {
            FSTextView(routine.name, typography: .h4)
            Spacer()
            Image(.iconBookmark)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    if superwall.isFirstDayTrialActive {
                        superwall.presentPaywall(for: .proContent)
                    }
                    triggerHaptics()
                }
        }
    }
  
    var workoutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            WrappedHStack(routine.muscleGroups, horizontalSpacing: 4, verticalSpacing: 4) { muscleGroup in
                GrayPillView(text: muscleGroup, fontStyle: .body14, cornerRadius: 24)
            }
            
            HStack(spacing: 8) {
                
                if let sets = routine.intSets {
                    WorkoutPillView(image: "icon_chart_orange", value: sets, label: "sets")
                }
                
                if let reps = routine.intReps {
                   
                    WorkoutPillView(image: "icon_repeat_purple", value: reps, label: "reps")
                }
                
                if let duration = routine.intDuration {
                    WorkoutPillView(image: "icon_clock_green", value: duration, label: "mins")
                        .frame(maxWidth: routine.timerOnly ? 100 : .infinity)
                }
            }
        }
    }
}
