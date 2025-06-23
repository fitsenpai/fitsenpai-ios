//
//  WorkoutDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation

final class WorkoutDataStore: SwiftDataStore<WorkoutWeekEntity> {
    
    func AddOrUpdateItem(entity: WorkoutWeekEntity) {
        guard let workdayEntity = items.first(where: { $0.startDate == entity.startDate && $0.endDate == entity.endDate }) else {
            add(entity)
            return
        }
        
        entity.days = workdayEntity.days
        update(entity)
    }
    
    func updateDayPlan(workoutDay: WorkoutDay) {
        guard let entity = items.first(where: { $0.days.contains(where: { $0.date == workoutDay.date }) }), let dayEntity = entity.days.first(where: { $0.date == workoutDay.date }) else { return }
                
        dayEntity.routines = workoutDay.routines.map { $0.toEntity() }
        dayEntity.totalTime = workoutDay.totalTime
        dayEntity.day = workoutDay.day
        dayEntity.totalRoutines = workoutDay.totalRoutines
        dayEntity.title = workoutDay.title
        dayEntity.pendingGeneration = workoutDay.pendingGeneration
        
        // Update the parent entity
        update(entity)
    }
    
    func updateSelectedItem(startDate: String, endDate: String, days: [WorkoutDayEntity]) {
        guard let entity = items.first(where: { $0.startDate == startDate && $0.endDate == endDate }) else { return }
        
        entity.days = days
        update(entity)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let entity = items[index]
            delete(entity)
        }
    }
    
    func delete(by startDate: String, endDate: String) {
        guard let entity = items.first(where: { $0.startDate == startDate && $0.endDate == endDate }) else {
            FSLogger.error("Week with dates \(startDate) - \(endDate) not found")
            return
        }
        delete(entity)
    }

    /// Deletes all messages from the data store.
    func deleteAll() {
        items.forEach { item in
            delete(item)
        }
    }
}
