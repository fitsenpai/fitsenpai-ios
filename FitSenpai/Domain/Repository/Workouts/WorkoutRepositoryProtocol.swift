//
//  WorkoutRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

protocol WorkoutRepositoryProtocol {
    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> WorkoutPlan
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutPlan
    func getWorkoutPlan() async throws -> WorkoutPlan?
}
