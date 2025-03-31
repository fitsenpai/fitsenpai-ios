//
//  WorkoutDetailViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import Foundation

class WorkoutDetailViewModel: ObservableObject {
    
    @Published var muscleGroups: [String]
    @Published var reps: Int
    @Published var sets: Int
    @Published var load: Int
    @Published var title: String
    @Published var url: URL?
    @Published var isComplete: Bool = false
    @Published var workoutSteps: [String]
    
    init(routine: Routine){
        self.muscleGroups = [routine.muscleGroup ?? ""]
        self.reps = Int(routine.repetition ?? "") ?? 0
        self.sets = Int(routine.sets ?? "") ?? 0
        self.load = Int(routine.load ?? "") ?? 0
        self.title = routine.name ?? ""
        self.url = URL(string: routine.gifUrl ?? "")
        self.workoutSteps = routine.instructions ?? []
    }
}
