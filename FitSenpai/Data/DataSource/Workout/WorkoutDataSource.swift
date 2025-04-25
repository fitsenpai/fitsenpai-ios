//
//  WorkoutDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol WorkoutDataSourceProtocol {
    func generateTrialWorkout(_ params: TrialWorkoutRequest) async throws -> WorkoutDTO
}

final class WorkoutDataSource: WorkoutDataSourceProtocol {
   
    // MARK: - Dependencies
    @Inject(key: "workout")
    private var networkService: NetworkService<WorkoutEndpoint>
    
    // MARK: - Auth API Calls
    
    func generateTrialWorkout(_ params: TrialWorkoutRequest) async throws -> WorkoutDTO {
        return try await networkService.request(.generateDemoWorkout(params))
    }
}
