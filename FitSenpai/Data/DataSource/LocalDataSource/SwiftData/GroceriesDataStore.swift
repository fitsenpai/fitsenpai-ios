//
//  GroceriesDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//


import Foundation

final class GroceriesDataStore: SwiftDataStore<GroceryWeekEntity> {
    
    func updateSelectedItem(_ groceryWeek: GroceryWeekEntity) {
        guard let entity = items.first(where: { $0.week == groceryWeek.week }) else { return }
        
        entity.shopping = groceryWeek.shopping
        update(entity)
    }
    
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
