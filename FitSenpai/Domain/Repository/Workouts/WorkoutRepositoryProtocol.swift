//
//  WorkoutRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

protocol WorkoutRepositoryProtocol {
    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> DailyWorkout
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> DailyWorkout
    func generateMealsDemo(_ params: WorkoutDemoRequest) async throws -> DailyWorkout
    func generateGroceriesDemo(_ params: WorkoutDemoRequest) async throws -> DailyWorkout
}
