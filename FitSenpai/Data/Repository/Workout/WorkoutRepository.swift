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
    @Inject private var routineDataStore: RoutineDataStore

    @AppState(\.trialStartDate) private var trialStartDate

    func generateWorkouts(_ params: GenerateRequest) async throws -> WeekPlan<WorkoutDay> {
        try await remoteDataSource.generateWorkout(params).toDomain()
    }
    
    func regenerateWorkouts(_ params: RegenerateRequest) async throws -> WorkoutDay {
        try await remoteDataSource.regenerateWorkout(params).toDomain()
    }
    
    func generateWorkoutDemo(_ params: WorkoutProfileRequest) async throws -> [WeekPlan<WorkoutDay>] {
        let workoutDay = try await remoteDataSource.generateWorkoutDemo(params).toDomain()
        let workoutWeek = WeekPlan<WorkoutDay>.init(startDate: Date().formatted(), endDate: Date().formatted(), days: [workoutDay])
        
        workoutDataStore.deleteAll()
        workoutDataStore.add(workoutWeek.toEntity())
        return [workoutWeek]
    }
    
    func getWorkoutPlan() async throws -> [WeekPlan<WorkoutDay>] {
        if trialStartDate != nil {
            return workoutDataStore.items.map({ $0.toDomain() })
        } else {
            let workoutPlanResponse = try await remoteDataSource.getWorkoutPlan()
            workoutDataStore.deleteAll()
            let domainPlan = workoutPlanResponse.plan.map { $0.toDomain() }
            return domainPlan
        }
    }
    
    func updateRoutine(id: String, date: String, name: String) async throws {
        if trialStartDate != nil {
            routineDataStore.toggleCompleted(id: id)
        } else {
            try await remoteDataSource.updateWorkoutRoutine(.init(date: date, name: name))
        }
    }
}
