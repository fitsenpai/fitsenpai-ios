//
//  SwiftDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/2/25.
//


import SwiftUI
import SwiftData

@MainActor
class SwiftDataStore<T: PersistentModel & Identifiable>: ObservableObject {
    
    @Published private(set) var items: [T] = []
    
    // Changed access level to internal so helper methods can use it.
    internal let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    func fetchItems() {
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            items = try modelContext.fetch(fetchDescriptor)
        } catch {
            logError("Failed to fetch items", error)
        }
    }
    
    func add(_ item: T) {
        modelContext.insert(item)
        saveContext()
    }
    
    func update(_ item: T) {
        saveContext()
    }
    
    func delete(_ item: T) {
        modelContext.delete(item)
        saveContext()
    }
    
    // MARK: - Batch Operations
    
    /// Inserts multiple items without immediately saving.
    func addBatch(_ newItems: [T]) {
        newItems.forEach { modelContext.insert($0) }
    }
    
    /// Saves the current state of the context and refreshes the items.
    func saveContext() {
        do {
            try modelContext.save()
            fetchItems()
        } catch {
            logError("Failed to save context", error)
        }
    }
    
    private func logError(_ message: String, _ error: Error) {
        print("\(message): \(error)")
    }
}
