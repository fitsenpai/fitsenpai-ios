//
//  WorkoutRepo.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation

protocol WorkoutRepo {
    func fetchAllWorkouts() async throws -> [Workout]
    func fetchWorkoutPlans(forUser userId: UUID) async throws -> [WorkoutPlan]
    func fetchDifficultyLevels() async throws -> [DifficultyLevel]
    func fetchFitnessGoals() async throws -> [FitnessGoal]
    func fetchGymActivities(forUser userId: UUID) async throws -> [GymActivity]
}

struct WorkoutRepoImpl: WorkoutRepo {
    private let client: FSClient

    init(client: FSClient = .shared!) {
        self.client = client
    }

    func fetchAllWorkouts() async throws -> [Workout] {
        let supabaseClient = client.getClient()

        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.workout.rawValue)
                .select()
                .execute()

            let data = response.data
            FSLogger.verbose(data)
            return try JSONDecoder().decode([Workout].self, from: data)
        } catch {
            throw error
        }
    }

    func fetchWorkoutPlans(forUser userId: UUID) async throws -> [WorkoutPlan] {
        let supabaseClient = client.getClient()

        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.workoutPlan.rawValue)
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()

            let data = response.data
            let workoutPlanArray = try JSONDecoder().decode([WorkoutPlan].self, from: data)
            FSLogger.verbose(workoutPlanArray)
            return workoutPlanArray
        } catch {
            throw error
        }
    }

    func fetchDifficultyLevels() async throws -> [DifficultyLevel] {
        let supabaseClient = client.getClient()

        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.difficultyLevel.rawValue)
                .select()
                .execute()

            let data = response.data

            return try JSONDecoder().decode([DifficultyLevel].self, from: data)
        } catch {
            throw error
        }
    }

    func fetchFitnessGoals() async throws -> [FitnessGoal] {
        let supabaseClient = client.getClient()

        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.fitnessGoals.rawValue)
                .select()
                .execute()

            let data = response.data
            
            return try JSONDecoder().decode([FitnessGoal].self, from: data)
        } catch {
            throw error
        }
    }

    func fetchGymActivities(forUser userId: UUID) async throws -> [GymActivity] {
        let supabaseClient = client.getClient()

        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.gymActivity.rawValue)
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()

            let data = response.data
            return try JSONDecoder().decode([GymActivity].self, from: data)
        } catch {
            throw error
        }
    }
}
