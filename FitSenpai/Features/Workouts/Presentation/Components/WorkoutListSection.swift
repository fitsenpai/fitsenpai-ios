import SwiftUI

struct WorkoutListSection: View {
    @ObservedObject var viewModel: WorkoutsMainViewModel
    @Binding var showingDetail: Bool
    @Binding var feedbackType: WorkoutSheetType?
    
    var body: some View {
        VStack(spacing: 16) {
            listingHeader
            FSCompletionBarView()
            if viewModel.isWorkoutLoading {
                ProgressView()
            } else {
                workoutList
            }
        }
        .padding(.vertical, 16)
    }
    
    private var listingHeader: some View {
        HStack(spacing: 12) {
            FSText(text: "Workouts", fontStyle: .heading25, color: .fsTitle)
            Spacer()
            
            HStack(spacing: 15) {
                regenerateButton
                feedbackButtons
            }
            .frame(height: 16)
        }
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
    
    private var workoutList: some View {
        ScrollView {
            VStack(spacing: 12) {
                Color.clear.frame(height: 2)
                ForEach(viewModel.workoutPlans, id: \.id) { workout in
                    WorkoutView(
                        image: "ic_workout",
                        title: workout.name ?? "",
                        videoURL: workout.url,
                        showInfo: true,
                        isSelected: workout == viewModel.selectedWorkout
                    )
                    .onTapGesture {
                        showingDetail.toggle()
                    }
                    .frame(height: 88)
                    .sheet(isPresented: $showingDetail) {
                        WorkoutDetailView(viewModel: WorkoutDetailViewModel(routine: Routine.initTest()))
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
