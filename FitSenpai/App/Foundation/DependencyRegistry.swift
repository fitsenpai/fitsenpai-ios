//
//  DependencyRegistry.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import CoreKit
import Foundation

/// A registry for managing and registering all dependencies needed for the FitSenpai app.
enum DependencyRegistry {
    
    /// Registers all necessary dependencies by calling each specific registration function.
    /// This function acts as a centralized place to register all services, data sources,
    /// repositories, and use cases needed by the app.
    static func registerAll() {
        registerNetworkServices()
        registerDataSources()
        registerRepositories()
        registerUseCases()
    }
    
    /// Registers network services with the `DependencyInjector`.
    ///
    /// This function registers the network service for authentication (`AuthEndpoint`),
    /// user management (`UserEndpoint`), and workout management (`WorkoutEndpoint`) using 
    /// the `DependencyInjector`. These services handle the API interactions for the app.
    static func registerNetworkServices() {
        DependencyInjector.register(NetworkService<AuthEndpoint>(), key: DIKey.auth.rawValue)
        DependencyInjector.register(NetworkService<UserEndpoint>(), key: DIKey.user.rawValue)
        DependencyInjector.register(NetworkService<WorkoutEndpoint>(), key: DIKey.workout.rawValue)
    }
    
    /// Registers data sources with the `DependencyInjector`.
    ///
    /// This function registers data sources for authentication, user, and workout
    /// management, each conforming to their respective protocols. Data sources are responsible 
    /// for fetching and providing data to the app.
    static func registerDataSources() {
        DependencyInjector.register(AuthDataSource() as any AuthDataSourceProtocol)
        DependencyInjector.register(UserDataSource() as any UserDataSourceProtocol)
        DependencyInjector.register(WorkoutDataSource() as any WorkoutDataSourceProtocol)
    }
    
    /// Registers repositories with the `DependencyInjector`.
    ///
    /// This function registers repositories for authentication, user, and workout management, 
    /// each conforming to their respective protocols. Repositories handle the business logic 
    /// and interact with data sources to provide data to the app.
    static func registerRepositories() {
        DependencyInjector.register(AuthRepository() as any AuthRepositoryProtocol)
        DependencyInjector.register(UserRepository() as any UserRepositoryProtocol)
        DependencyInjector.register(WorkoutRepository() as any WorkoutRepositoryProtocol)
    }
    
    /// Registers use cases with the `DependencyInjector`.
    ///
    /// This function registers use cases such as signing in, signing out, fetching user data,
    /// and managing trial workouts. Use cases represent the app's core business logic and are
    /// responsible for executing the app's actions based on user requests.
    static func registerUseCases() {
        DependencyInjector.register(SigninUseCase() as any SigninUseCaseProtocol)
        DependencyInjector.register(SignOutUseCase() as any SignOutUseCaseProtocol)
        DependencyInjector.register(GetUserUseCase() as any GetUserUseCaseProtocol)
        DependencyInjector.register(GetUserProfileUseCase() as any GetUserProfileUseCaseProtocol)
        DependencyInjector.register(TrialWorkoutUseCase() as any TrialWorkoutUseCaseProtocol)
    }
}
