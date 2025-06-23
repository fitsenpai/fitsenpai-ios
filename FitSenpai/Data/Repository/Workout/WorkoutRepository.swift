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

    func generateWorkouts(_ params: GenerateWorkoutRequest) async throws -> WeekPlan<WorkoutDay> {
        try await remoteDataSource.generateWorkout(params).toDomain()
    }
    
    func regenerateWorkouts(_ params: RegenerateWorkoutRequest) async throws -> WorkoutDay {
        try await remoteDataSource.regenerateWorkout(params).toDomain()
    }
    
    func generateWorkoutDemo(_ params: WorkoutDemoRequest) async throws -> [WeekPlan<WorkoutDay>] {
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
    
    func updateRoutine(_ id: String) async throws {
        // Find the routine in the workout data store hierarchy and update it
        for weekEntity in workoutDataStore.items {
            for dayEntity in weekEntity.days {
                if let routineEntity = dayEntity.routines.first(where: { $0.id == id }) {
                    routineEntity.isCompleted.toggle()
                    workoutDataStore.update(weekEntity)
                    return
                }
            }
        }
        
        // Fallback: if not found in workout store, try routine store
        routineDataStore.toggleCompleted(id: id)
    }
}
