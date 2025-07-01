//
//  WorkoutDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol WorkoutDataSourceProtocol {
    func getWorkoutPlan() async throws -> WorkoutPlanResponse
    func generateWorkout(_ params: GenerateRequest) async throws -> WorkoutWeekDTO
    func regenerateWorkout(_ params: RegenerateRequest) async throws -> WorkoutDayDTO
    func generateWorkoutDemo(_ params: WorkoutProfileRequest) async throws -> WorkoutDayDTO
    func updateWorkoutRoutine(_ params: UpdateRoutineRequest) async throws 
}

final class WorkoutDataSource: WorkoutDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "workout")
    private var networkService: NetworkService<WorkoutEndpoint>
    
    // MARK: - API Calls
    
    func getWorkoutPlan() async throws -> WorkoutPlanResponse {
        try await networkService.request(.getWorkoutPlan)
    }
    
    func generateWorkout(_ params: GenerateRequest) async throws -> WorkoutWeekDTO {
        try await networkService.request(.generateWorkoutPlan(params))
    }
    
    func regenerateWorkout(_ params: RegenerateRequest) async throws -> WorkoutDayDTO {
        try await networkService.request(.regenerateWorkoutPlan(params))
    }
    
    func generateWorkoutDemo(_ params: WorkoutProfileRequest) async throws -> WorkoutDayDTO {
        try await networkService.request(.generateWorkoutDemo(params))
    }
    
    func updateWorkoutRoutine(_ params: UpdateRoutineRequest) async throws {
        try await networkService.request(.updateWorkoutRoutine(params))
    }
}
