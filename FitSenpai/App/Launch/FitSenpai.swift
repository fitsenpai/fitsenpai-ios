//
//  FitSenpai.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI
import Foundation
import SwiftData

/// Global environment object shared across the app.
let globalAppEnvObject = GlobalAppEnvironment()

/// The main entry point for the app, responsible for initializing the application environment,
/// including setting up model context, dependencies, and managing the app's main state.
@main
struct FitSenpai: App {
    
    /// The app delegate for managing app lifecycle events.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// The main view model for managing app state and interactions.
    @StateObject private var appState = AppViewModel()
    
    /// The shared model context used for interacting with SwiftData.
    private let modelContext: ModelContext
    
    /// Shared instance for managing in-app purchases via Superwall.
    private let superwallManager = SuperwallManager.shared
    
    /// Initializes the app's environment by setting up the model context and dependencies.
    /// - Throws: An error if the ModelContainer cannot be initialized.
    init() {
        do {
            // Initialize the model context using predefined entities.
            self.modelContext = try Self.makeModelContext()
            
            // Setup the dependencies required for the app.
            self.setupDependencies()
        } catch {
            // Fatal error if model context setup fails.
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    /// The body of the app, responsible for defining the initial scene and views.
    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(.light)
                .environment(\.modelContext, modelContext)
                .environmentObject(superwallManager)
                .environmentObject(appState)
        }
    }
    
    /// Creates the model context for interacting with the app's persistent data model.
    /// - Returns: A `ModelContext` instance configured with the app's entity types.
    /// - Throws: An error if the model container cannot be created.
    private static func makeModelContext() throws -> ModelContext {
        // Creating a model container for app's persistent entities.
        let container = try ModelContainer(
            for: UserProfileEntity.self,
            WorkoutPlanEntity.self,
            WorkoutWeekEntity.self,
            WorkoutDayEntity.self,
            RoutineEntity.self,
            DailyMealPlanEntity.self,
            MealsPlanEntity.self,
            MealEntity.self,
            MacrosEntity.self,
            GroceryPlanEntity.self,
            GroceryItemEntity.self,
            ShoppingCategoryEntity.self
        )
        // Return a model context initialized with the container.
        return ModelContext(container)
    }
    
    /// Registers the core services required for the app, including dependencies and data stores.
    /// - This method is called after the model context is created to ensure everything is set up before use.
    private func setupDependencies() {
        // Register core services.
        DependencyRegistry.registerDependencies()
        
        // Register data stores with the model context.
        DependencyRegistry.registerDataStores(modelContext: self.modelContext)
    }
}

/// A utility function to trigger haptic feedback, typically used for providing tactile feedback to users.
/// - This function utilizes the UIImpactFeedbackGenerator to provide a light impact.
public func triggerHaptics() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred() // Trigger a light haptic feedback.
}
