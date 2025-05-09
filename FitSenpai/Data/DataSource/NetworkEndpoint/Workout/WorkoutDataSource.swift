//
//  WorkoutDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol WorkoutDataSourceProtocol {
    func getWorkoutPlan(_ params: WorkoutDemoRequest) async throws -> WorkoutPlanDTO
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDayDTO
}

final class WorkoutDataSource: WorkoutDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "workout")
    private var networkService: NetworkService<WorkoutEndpoint>
    
    // MARK: - API Calls
    
    func getWorkoutPlan(_ params: WorkoutDemoRequest) async throws -> WorkoutPlanDTO {
        try await networkService.request(.getWorkoutPlan(params))
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDayDTO {
        try await networkService.request(.generateWorkoutDemo(params))
    }
}
