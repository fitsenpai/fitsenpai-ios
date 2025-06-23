//
//  WorkoutRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

protocol WorkoutRepositoryProtocol {
    func generateWorkouts(_ params: GenerateRequest) async throws -> WeekPlan<WorkoutDay>
    func regenerateWorkouts(_ params: RegenerateRequest) async throws -> WorkoutDay
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> [WeekPlan<WorkoutDay>]
    func getWorkoutPlan() async throws -> [WeekPlan<WorkoutDay>]
    func updateRoutine(_ id: String) async throws
}
