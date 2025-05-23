//
//  WorkoutDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation

final class WorkoutDataStore: SwiftDataStore<WorkoutWeekEntity> {
    
    func updateSelectedItem(week: Int, days: [WorkoutDayEntity]) {
        guard let entity = items.first(where: { $0.week == week }) else { return }
        
        entity.days = days
        update(entity)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let entity = items[index]
            delete(entity)
        }
    }
    
    func delete(by week: Int) {
        guard let entity = items.first(where: { $0.week == week }) else {
            FSLogger.error("\(week) not found")
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
