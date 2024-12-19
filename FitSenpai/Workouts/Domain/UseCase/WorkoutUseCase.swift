//
//  WorkoutUseCase.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation

struct WorkoutUseCase {
    private let workoutRepo: WorkoutRepo

    init(workoutRepo: WorkoutRepo) {
        self.workoutRepo = workoutRepo
    }

    // Fetch all workouts
    func fetchAllWorkouts() async throws -> [Workout] {
        return try await workoutRepo.fetchAllWorkouts()
    }

    // Fetch workout plans for a user
    func fetchWorkoutPlans(forUser userId: UUID, date: Date) async throws -> [DailyWorkoutPlan] {
        return try await workoutRepo.fetchWorkoutPlans(forUser: userId, date: date)
    }

    // Fetch all difficulty levels
    func fetchDifficultyLevels() async throws -> [DifficultyLevel] {
        return try await workoutRepo.fetchDifficultyLevels()
    }

    // Fetch all fitness goals
    func fetchFitnessGoals() async throws -> [FitnessGoal] {
        return try await workoutRepo.fetchFitnessGoals()
    }

    // Fetch gym activities for a user
    func fetchGymActivities(forUser userId: UUID) async throws -> [GymActivity] {
        return try await workoutRepo.fetchGymActivities(forUser: userId)
    }
    
    // Fetch weekly plan for a user
    func fetchWeeklyPlan(forUser userId: UUID, date: Date) async throws -> [WeeklyPlan] {
        return try await workoutRepo.fetchWeeklyPlan(forUser: userId, date: date)
    }
    
    func fetchWeekToGenerate(forUser userId: UUID) async throws -> Int? {
        return try await workoutRepo.fetchWeekToGenerate(forUser: userId)
    }
}
