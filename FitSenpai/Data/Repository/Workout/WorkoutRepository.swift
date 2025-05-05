//
//  WorkoutRepositoryError.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation
import CoreKit

final class WorkoutRepository: WorkoutRepositoryProtocol {
   
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: WorkoutDataSourceProtocol

    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> WorkoutDay {
        try await remoteDataSource.getWorkoutPlan(params).toDomain()
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDay {
        try await remoteDataSource.generateWorkoutDemo(params).toDomain()
    }
    
    func generateMealsDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDay {
        fatalError("Function not implemented")
    }
    
    func generateGroceriesDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutDay {
        fatalError("Function not implemented")
    }
    
}
