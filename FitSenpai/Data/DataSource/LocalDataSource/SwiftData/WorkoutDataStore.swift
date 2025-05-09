//
//  WorkoutDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation

final class WorkoutDataStore: SwiftDataStore<WorkoutPlanEntity> {
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let entity = items[index]
            delete(entity)
        }
    }
    
    func delete(by id: String) {
        guard let entity = items.first(where: { $0.id == id }) else {
            FSLogger.error("Profile with id \(id) not found")
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
