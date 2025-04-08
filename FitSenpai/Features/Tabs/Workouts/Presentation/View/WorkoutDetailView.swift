//
//  WorkoutDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI
import AVKit

struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutDetailViewModel
    
    @State private var player = AVPlayer(url: URL(string: UserDefaults.standard.string(forKey: "videoURL") ?? "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/abdominals/seated_floor_crunches.mp4?")!)
    
    private var subviewWidth: CGFloat {
        let w = UIScreen.main.bounds.width - 32
        return (w - 1 * 2 - 8 * 2) / 3 // Calculate the width for each subview
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
            HStack {
                FSText(text: viewModel.title, fontStyle: .heading20, color: .fsTitle)
                Spacer()
                Image(.iconBookmark)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
            targetGroupHorizontalList
            workoutInfoHorizontalView
        }
    }
    
    var body: some View {
        VStack {
            SheetIndicator()
            VStack(spacing: 24) {
                workoutSection
                PlayerView(player: $player)
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
                FSButton(title: "Complete", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    dismiss()
                })
            }
        }
        .padding(16)
        .background {
            Color.workoutBackgroundColor
        }
        
    }
}

struct WorkoutsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutDetailViewModel(routine: Routine.initTest())
        WorkoutDetailView(viewModel: viewModel)
    }
}
