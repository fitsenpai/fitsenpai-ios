//
//  DependencyRegistry.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import CoreKit
import Foundation
import SwiftData

/// A registry for managing and registering all dependencies needed for the FitSenpai app.
enum DependencyRegistry {
    
    /// Registers all necessary dependencies by calling each specific registration function.
    /// This function acts as a centralized place to register all services, data sources,
    /// repositories, and use cases needed by the app.
    static func registerDependencies() {
        registerNetworkServices()
        registerDataSources()
        registerRepositories()
        registerUseCases()
    }
    
    /// Registers network services with the `DependencyInjector`.
    ///
    /// This function registers the network services. These services handle the API interactions for the app.
    static func registerNetworkServices() {
        DependencyInjector.register(NetworkService<AuthEndpoint>(), key: "auth")
        DependencyInjector.register(NetworkService<UserEndpoint>(), key: "user")
        DependencyInjector.register(NetworkService<WorkoutEndpoint>(), key: "workout")
        DependencyInjector.register(NetworkService<MealsEndpoint>(), key: "meals")
        DependencyInjector.register(NetworkService<GroceryEndpoint>(), key: "grocery")
        DependencyInjector.register(NetworkService<FeedbackEndpoint>(), key: "feedback")
        DependencyInjector.register(NetworkService<WeightsEndpoint>(), key: "weights")
    }
    
    /// Registers data sources with the `DependencyInjector`.
    ///
    /// This function registers data sources, each conforming to their respective protocols.
    /// Data sources are responsible for fetching and providing data to the app.
    static func registerDataSources() {
        DependencyInjector.register(AuthDataSource() as any AuthDataSourceProtocol)
        DependencyInjector.register(UserDataSource() as any UserDataSourceProtocol)
        DependencyInjector.register(WorkoutDataSource() as any WorkoutDataSourceProtocol)
        DependencyInjector.register(MealsDataSource() as any MealsDataSourceProtocol)
        DependencyInjector.register(GroceryDataSource() as any GroceryDataSourceProtocol)
        DependencyInjector.register(FeedbackDataSource() as any FeedbackDataSourceProtocol)
        DependencyInjector.register(WeightsDataSource() as any WeightsDataSourceProtocol)
    }
    
    /// Registers repositories with the `DependencyInjector`.
    ///
    /// This function registers repositories, each conforming to their respective protocols.
    /// Repositories handle the business logic
    /// and interact with data sources to provide data to the app.
    static func registerRepositories() {
        DependencyInjector.register(AuthRepository() as any AuthRepositoryProtocol)
        DependencyInjector.register(UserRepository() as any UserRepositoryProtocol)
        DependencyInjector.register(WorkoutRepository() as any WorkoutRepositoryProtocol)
        DependencyInjector.register(MealsRepository() as any MealsRepositoryProtocol)
        DependencyInjector.register(GroceryRepository() as any GroceryRepositoryProtocol)
        DependencyInjector.register(FeedbackRepository() as any FeedbackRepositoryProfocol)
        DependencyInjector.register(WeightsRepository() as any WeightsRepositoryProtocol)
    }
    
    /// Registers use cases with the `DependencyInjector`.
    ///
    /// This function registers use cases.
    /// Use cases represent the app's core business logic and are
    /// responsible for executing the app's actions based on user requests.
    static func registerUseCases() {
        DependencyInjector.register(ForgotPasswordUseCase() as any ForgotPasswordUseCaseProtocol)
        DependencyInjector.register(ResetPasswordUseCase() as any ResetPasswordUseCaseProtocol)
        DependencyInjector.register(VerifyOTPUseCase() as any VerifyOTPUseCaseProtocol)
        DependencyInjector.register(DeleteAccountUseCase() as any DeleteAccountUseCaseProtocol)
        DependencyInjector.register(SigninUseCase() as any SigninUseCaseProtocol)
        DependencyInjector.register(SignOutUseCase() as any SignOutUseCaseProtocol)
        DependencyInjector.register(GetUserAuthUseCase() as any GetUserAuthUseCaseProtocol)
        DependencyInjector.register(GetUserProfileUseCase() as any GetUserProfileUseCaseProtocol)
        DependencyInjector.register(CreateProfileUseCase() as any CreateProfileUseCaseProtocol)
        DependencyInjector.register(WorkoutDemoUseCase() as any WorkoutDemoUseCaseProtocol)
        DependencyInjector.register(WorkoutPlanUseCase() as any WorkoutPlanUseCaseProtocol)
        DependencyInjector.register(GenerateWorkoutUseCase() as any GenerateWorkoutUseCaseProtocol)
        DependencyInjector.register(RegenerateWorkoutUseCase() as any RegenerateWorkoutUseCaseProtocol)
        DependencyInjector.register(MealPlanDemoUseCase() as any MealPlanDemoUseCaseProtocol)
        DependencyInjector.register(GenerateMealsPlanUseCase() as any GenerateMealsPlanUseCaseProtocol)
        DependencyInjector.register(RegenerateMealsPlanUseCase() as any RegenerateMealsPlanUseCaseProtocol)
        DependencyInjector.register(SaveUserProfileUseCase() as any SaveUserProfileUseCaseProtocol)
        DependencyInjector.register(MealsPlanUseCase() as any MealsPlanUseCaseProtocol)
        DependencyInjector.register(MealsPlanUseCase() as any MealsPlanUseCaseProtocol)
        DependencyInjector.register(GroceryPlanUseCase() as any GroceryPlanUseCaseProtocol)
        DependencyInjector.register(GroceryTogleUseCase() as any GroceryTogleUseCaseProtocol)
        DependencyInjector.register(UpdateGroceryUseCase() as any UpdateGroceryUseCaseProtocol)
        DependencyInjector.register(UpdateRoutineUseCase() as any UpdateRoutineUseCaseProtocol)
        DependencyInjector.register(SendFeedbackUseCase() as any SendFeedbackUseCaseProtocol)
        DependencyInjector.register(GetWeigthsUseCase() as any GetWeightsUseCaseProtocol)
        DependencyInjector.register(CreateWeigthsUseCase() as any CreateWeightsUseCaseProtocol)
        DependencyInjector.register(GetBMIUseCase() as any GetBMIUseCaseProtocol)
    }
    
    @MainActor static func registerDataStores(modelContext: ModelContext) {
        DependencyInjector.register(ProfileDataStore(modelContext: modelContext))
        DependencyInjector.register(WorkoutDataStore(modelContext: modelContext))
        DependencyInjector.register(MealsDataStore(modelContext: modelContext))
        DependencyInjector.register(GroceriesDataStore(modelContext: modelContext))
        DependencyInjector.register(RoutineDataStore(modelContext: modelContext))
        /// Add more stores as needed
    }
}
