//
//  WorkoutDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI
import AVKit

struct WorkoutDetailView: View {
    
    @ObservedObject var viewModel: WorkoutDetailViewModel
    
    @State private var player = AVPlayer(url: URL(string: UserDefaults.standard.string(forKey: "videoURL") ?? "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/abdominals/seated_floor_crunches.mp4?")!)
    
    private var subviewWidth: CGFloat {
        let w = UIScreen.main.bounds.width - 32
        return (w - 1 * 2 - 8 * 2) / 3 // Calculate the width for each subview
    }
    
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            FSText(text: viewModel.title, fontStyle: .headers20, color: .fsTitle)
            Spacer()
        }
    }
    
    var targetGroupHorizontalList: some View {
        HStack (spacing: 12) {
            ForEach(viewModel.muscleGroups, id: \.self) { muscleGroup in
                GrayPillView(text: muscleGroup, pillHeight: 32, fontStyle: .body16)
                Spacer()
            }
        }
    }
    
    var workoutInfoHorizontalView: some View {
        HStack(spacing: 8) {
            IconLabelView(
                fsMetric: .WorkoutSet,
                value: viewModel.sets,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 16,
                showBorder: true, width: subviewWidth
            )
            .frame(width: subviewWidth)
            
            IconLabelView(
                fsMetric: .WorkoutRep,
                value: viewModel.reps,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 16,
                showBorder: true, width: subviewWidth
            )
            .frame(width: subviewWidth)
            
            IconLabelView(
                fsMetric: .WorkoutWeight,
                value: viewModel.load,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 16,
                showBorder: true, width: subviewWidth
            )
            .frame(width: subviewWidth)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
    
    var workoutSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                listingHeader
                targetGroupHorizontalList
            }
            .padding(.bottom, 8)
            workoutInfoHorizontalView
        }
        .padding(.vertical, 16)
    }
    
    var body: some View {
        VStack {
            workoutSection
            PlayerView(player: $player)
                            .onAppear() {
                                player.play()
                            }.ignoresSafeArea()
            GenericTextListView(title: "How to perform this exercise:", instructions: viewModel.workoutSteps, isNumbered: true)
                .padding(.bottom, 16)
            FSButton(title: "Complete", tapAction: {})
        }
        .background {
            Color.workoutBackgroundColor
        }
        .padding(16)
        
    }
}

struct WorkoutsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutDetailViewModel(routine: Routine.initTest())
        WorkoutDetailView(viewModel: viewModel)
    }
}
