//
//  DependencyRegistry.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

enum DependencyRegistry {
    
    static func registerAll() {
        registerNetworkServices()
        registerDataSources()
        registerRepositories()
        registerUseCases()
    }
    
    static func registerNetworkServices() {
        DependencyInjector.register(NetworkService<AuthEndpoint>(), key: .auth)
        DependencyInjector.register(NetworkService<UserEndpoint>(), key: .user)
        DependencyInjector.register(NetworkService<WorkoutEndpoint>(), key: .workout)
    }
    
    static func registerDataSources() {
        DependencyInjector.register(AuthDataSource() as any AuthDataSourceProtocol)
        DependencyInjector.register(UserDataSource() as any UserDataSourceProtocol)
        DependencyInjector.register(WorkoutDataSource() as any WorkoutDataSourceProtocol)
    }
    
    static func registerRepositories() {
        DependencyInjector.register(AuthRepository() as any AuthRepositoryProtocol)
        DependencyInjector.register(UserRepository() as any UserRepositoryProtocol)
        DependencyInjector.register(WorkoutRepository() as any WorkoutRepositoryProtocol)
    }
    
    static func registerUseCases() {
        DependencyInjector.register(SigninUseCase() as any SigninUseCaseProtocol)
        DependencyInjector.register(SignOutUseCase() as any SignOutUseCaseProtocol)
        DependencyInjector.register(GetUserUseCase() as any GetUserUseCaseProtocol)
        DependencyInjector.register(GetUserProfileUseCase() as any GetUserProfileUseCaseProtocol)
        DependencyInjector.register(TrialWorkoutUseCase() as any TrialWorkoutUseCaseProtocol)
    }
}
