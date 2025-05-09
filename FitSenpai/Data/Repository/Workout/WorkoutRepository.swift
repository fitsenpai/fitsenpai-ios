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

    @Inject private var workoutDataStore: WorkoutDataStore

    @AppState(\.trialStartDate) private var trialStartDate

    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> WorkoutPlan {
        try await remoteDataSource.getWorkoutPlan(params).toDomain()
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> WorkoutPlan {
        let workoutDay = try await remoteDataSource.generateWorkoutDemo(params).toDomain()
        let workoutWeek = WorkoutWeek(week: 1, startDate: Date().formatted(), endDate: Date().formatted(), days: [workoutDay])
        let workoutPlan = WorkoutPlan(
            id: UUID().uuidString,
            weeks: [workoutWeek],
            createdAt: Date().formatted(),
            updatedAt: Date().formatted(),
            userId: UUID().uuidString, profileId: UUID().uuidString
        )
        workoutDataStore.deleteAll()
        workoutDataStore.add(workoutPlan.toEntity())
        return workoutPlan
    }
    
    func getWorkoutPlan() async throws -> WorkoutPlan? {
        return workoutDataStore.items.first?.toDomain()
    }
    
}
