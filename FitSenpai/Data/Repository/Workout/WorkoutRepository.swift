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

    func generateWorkouts(_ params: WorkoutDemoRequest) async throws -> [WeekPlan<WorkoutDay>] {
        let response = try await remoteDataSource.getWorkoutPlan()
        return response.plan.map({ $0.toDomain() })
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
    
    // MARK: - Private Helper Methods
    
    private func preserveCompletionStates() -> [String: Bool] {
        var completionStates: [String: Bool] = [:]
        
        workoutDataStore.items.forEach { weekEntity in
            weekEntity.days.forEach { dayEntity in
                dayEntity.routines.forEach { routineEntity in
                    completionStates[routineEntity.id] = routineEntity.isCompleted
                }
            }
        }
        
        return completionStates
    }
    
    private func restoreCompletionStates(_ workoutPlan: [WeekPlan<WorkoutDay>], existingStates: [String: Bool]) -> [WeekPlan<WorkoutDay>] {
        return workoutPlan.map { weekPlan in
            let updatedDays = weekPlan.days.map { day in
                let updatedRoutines = day.routines.map { routine in
                    if let savedState = existingStates[routine.id] {
                        routine.isCompleted = savedState
                    }
                    return routine
                }
                day.routines = updatedRoutines
                return day
            }
            weekPlan.days = updatedDays
            return weekPlan
        }
    }
}
