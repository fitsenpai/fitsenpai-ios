//
//  WorkoutRepo.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import ObjectMapper

protocol WorkoutRepo {
    func fetchAllWorkouts() async throws -> [Workout]
    func fetchWorkoutPlans(forUser userId: UUID, date: Date) async throws -> [DailyWorkoutPlan]
    func fetchDifficultyLevels() async throws -> [DifficultyLevel]
    func fetchFitnessGoals() async throws -> [FitnessGoal]
    func fetchGymActivities(forUser userId: UUID) async throws -> [GymActivity]
    func fetchWeeklyPlan(forUser userId: UUID, date queryDate: Date) async throws -> [WeeklyPlan]
    func fetchWeekToGenerate (forUser userId: UUID) async throws -> Int?
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

    func fetchWorkoutPlans(forUser userId: UUID, date queryDate: Date) async throws -> [DailyWorkoutPlan] {
        let supabaseClient = client.getClient()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: queryDate)


        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.workoutPlan.rawValue)
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("date", value: formattedDate)
                .execute()

            let data = response.data
            // Print the raw JSON data as a string to inspect it
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Raw JSON response: \(jsonString)")
//            }
            let workoutPlanArray = try JSONDecoder().decode([DailyWorkoutPlan].self, from: data)
//            FSLogger.verbose(workoutPlanArray)
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
    
    func fetchWeeklyPlan(forUser userId: UUID, date queryDate: Date) async throws -> [WeeklyPlan] {
        let supabaseClient = client.getClient()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: queryDate)
        FSLogger.verbose(formattedDate)
        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.weeklyPlansTest.rawValue) // Reference to your weekly_plans_test table
                .select()
                .eq("user_id", value: userId.uuidString)  // Assuming there's a user_id column
                .eq("start_date", value: formattedDate)
                .order("created_at")
                .execute()

            let data = response.data
            // Convert raw data to a JSON object
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            // Map JSON to the WeeklyPlan array
            let weeklyPlanArray = Mapper<WeeklyPlan>().mapArray(JSONArray: json ?? [])
            FSLogger.verbose(weeklyPlanArray)
            return weeklyPlanArray
        } catch {
            throw error
        }
    }
    
    func fetchWeekToGenerate (forUser userId: UUID) async throws -> Int? {
        let supabaseClient = client.getClient()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            let response = try await supabaseClient
                .database
                .from(FSTable.weeklyPlansTest.rawValue) // Reference to your weekly_plans_test table
                .select("week_number")
                .eq("user_id", value: userId.uuidString)
                .order("week_number", ascending: false)
                .limit(1)
                .execute()

            if let jsonArray = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]],
               let maxWeekNumber = jsonArray.first?["week_number"] as? Int {
                return maxWeekNumber
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}
