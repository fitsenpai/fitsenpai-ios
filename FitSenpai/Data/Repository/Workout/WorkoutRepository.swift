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

    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> [WeekPlan<WorkoutDay>] {
        let response = try await remoteDataSource.getWorkoutPlan(params)
        return response.plan.map({ $0.toDomain() })
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> [WeekPlan<WorkoutDay>] {
        let workoutDay = try await remoteDataSource.generateWorkoutDemo(params).toDomain()
        let workoutWeek = WeekPlan<WorkoutDay>.init(week: 1, startDate: Date().formatted(), endDate: Date().formatted(), days: [workoutDay])
        
        workoutDataStore.deleteAll()
        workoutDataStore.add(workoutWeek.toEntity())
        return [workoutWeek]
    }
    
    func getWorkoutPlan() async throws -> [WeekPlan<WorkoutDay>] {
        return workoutDataStore.items.map({ $0.toDomain() })
    }
    
    func updateRoutine(week: Int, days: [WorkoutDayEntity]) async throws {
        workoutDataStore.updateSelectedItem(week: week, days: days)
    }
    
}
