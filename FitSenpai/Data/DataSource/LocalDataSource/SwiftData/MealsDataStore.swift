//
//  MealsDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation

final class MealsDataStore: SwiftDataStore<MealsWeekEntity> {
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let entity = items[index]
            delete(entity)
        }
    }
    
    /// Deletes all messages from the data store.
    func deleteAll() {
        items.forEach { item in
            delete(item)
        }
    }
}
