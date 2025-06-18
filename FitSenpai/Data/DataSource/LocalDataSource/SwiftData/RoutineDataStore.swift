//
//  RoutineDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/9/25.
//

import Foundation

final class RoutineDataStore: SwiftDataStore<RoutineEntity> {
    
    func toggleCompleted(id: String) {
        guard let entity = items.first(where: { $0.id == id }) else { return }
        
        entity.isCompleted.toggle()
        update(entity)
    }
    
    /// Deletes all messages from the data store.
    func deleteAll() {
        items.forEach { item in
            delete(item)
        }
    }
}
