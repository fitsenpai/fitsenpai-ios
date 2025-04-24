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
    }
    
    static func registerDataSources() {
        DependencyInjector.register(AuthDataSource() as any AuthDataSourceProtocol)
        DependencyInjector.register(UserDataSource() as any UserDataSourceProtocol)
    }
    
    static func registerRepositories() {
        DependencyInjector.register(AuthRepository() as any AuthRepositoryProtocol)
        DependencyInjector.register(UserRepository() as any UserRepositoryProtocol)
    }
    
    static func registerUseCases() {
        DependencyInjector.register(SigninUseCase() as any SigninUseCaseProtocol)
        DependencyInjector.register(SignOutUseCase() as any SignOutUseCaseProtocol)
        DependencyInjector.register(GetUserUseCase() as any GetUserUseCaseProtocol)
        DependencyInjector.register(GetUserProfileUseCase() as any GetUserProfileUseCaseProtocol)
    }
}
