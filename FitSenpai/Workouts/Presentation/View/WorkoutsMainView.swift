//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI
import BottomSheet

struct WorkoutsMainView: View {
    @StateObject var viewModel: WorkoutsMainViewModel
    @State private var showingDetail = false
    @State private var selectedDate: Date = Date() {
        didSet {
            if let uuid = globalAppEnvObject.user?.id {
                viewModel.fetchWorkoutPlans(forUser: uuid, date: selectedDate)
            }
        }
    }
    @State private var currentWeekStartDate: Date = Date()
    @State var upcomingWeekNumber: Int?
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            Image("ic_barbel_green")
                .resizable()
                .frame(width: 32, height: 32)
            FSText(text: "Today's workout", fontStyle: .headers20, color: .fsTitle)
            Spacer()
        }
    }
    
    var targetGroupHorizontalList: some View {
        HStack (spacing: 12) {
            GrayPillView(text: viewModel.selectedTargetGroup, pillHeight: 32, fontStyle: .body16)
            Spacer()
        }
    }
    
    var workoutSection: some View {
        VStack(spacing: 16) {
            VStack {
                listingHeader
                targetGroupHorizontalList
            }
            FSCompletionBarView()
            
            if viewModel.isWorkoutLoading {
                ProgressView() // Show loading indicator while fetching
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.workoutPlans, id: \.id) { workout in
                            WorkoutView(image: "ic_workout", title: workout.name ?? "", videoURL: workout.url , showInfo: true, isSelected: workout == viewModel.selectedWorkout)
                                .onTapGesture {
                                    viewModel.selectWorkout(workout: workout)
                                }
                                .frame(height: 88)
                                .sheet(isPresented: $showingDetail) {
                                    WorkoutDetailView(viewModel: WorkoutDetailViewModel(routine: Routine.initTest()))
                                }
                                
                                
                        }
                        
//                        WorkoutView(image: "ic_workout", title: "General warm-up", isSelected: false, showInfo: false)
//                            .frame(height: 88)
//                            .onTapGesture {
//                                showingDetail = true
//                            }
//                            .sheet(isPresented: $showingDetail) {
//                                WorkoutDetailView(viewModel: WorkoutDetailViewModel(routine: Routine.initTest()))
//                            }
//
//                        WorkoutView(image: "ic_workout", title: "Bench press", isSelected: true, showInfo: true)
//                            .frame(height: 88)
//                            .onTapGesture {
//                                showingDetail = true
//                            }
//                            .sheet(isPresented: $showingDetail) {
//                                WorkoutDetailView(viewModel: WorkoutDetailViewModel(routine: Routine.initTest()))
//                            }
//
//                        .padding(.horizontal, 1)
                    }
                }
                .scrollIndicators(.hidden)
            }
            
        }
        .padding(.vertical, 16)
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FSText(text: "Workout planner", fontStyle: .headers24, color: .fsTitle)
            SwipeableCalendarView(selectedDate: $selectedDate, currentWeekStartDate: $currentWeekStartDate)
            if let upcomingWeekNumber = viewModel.upNextWeekNumber {
                VStack {
                    BackgroundInfoView(viewModel: BackgroundInfoViewModel(iconName: "ic_calendar_check", iconTint: .fsPrimary, title: "Week \(upcomingWeekNumber) is now unlocked", mainLabel: "Tap below to generate your new workout and\nmeal plans. This may take a few minutes.", buttonLabel: "Generate plans", buttonAction: {
                        //
                    }))
                    .padding(.top, 20)
                    Spacer()
                }
            }else{
                workoutSection
            }
            
        }
        .padding(.horizontal, 16)
        .onAppear {
            // Assuming we want to fetch workouts when the view appears
            if let uuid = globalAppEnvObject.user?.id {
                viewModel.fetchWorkoutPlans(forUser: uuid, date: selectedDate)
            }
            
        }
        .onChange(of: selectedDate, { oldValue, newValue in
            if let uuid = globalAppEnvObject.user?.id {
                viewModel.fetchWorkoutPlans(forUser: uuid, date: newValue)
            }
        })
        .onChange(of: currentWeekStartDate, { oldValue, newValue in
            // React to changes in currentWeekStartDate
            if let uuid = globalAppEnvObject.user?.id {
//                // Fetch workout plans based on the new start date of the week
//                viewModel.fetchWorkoutPlans(forUser: uuid, date: newStartDate)
                viewModel.fetchWeeklyPlan(forUser: uuid, date: newValue)
            }
        })
    }
    
    static func create() -> WorkoutsMainView {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        return WorkoutsMainView(viewModel: viewModel)
    }
}

struct WorkoutsMainView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        WorkoutsMainView(viewModel: viewModel)
    }
}
