//
//  WorkoutDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol WorkoutDataSourceProtocol {
    func getWorkoutPlan(_ params: WorkoutDemoRequest) async throws -> WorkoutDTO
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDTO
}

final class WorkoutDataSource: WorkoutDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "workout")
    private var networkService: NetworkService<WorkoutEndpoint>
    
    // MARK: - API Calls
    
    func getWorkoutPlan(_ params: WorkoutDemoRequest) async throws -> WorkoutDTO {
        fatalError("function has not been implemented")
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDTO {
        try await networkService.request(.generateWorkoutDemo(params))
    }
}
