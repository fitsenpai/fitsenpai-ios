//
//  DependencyRegistry.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

enum DependencyRegistry {
    static func registerNetworkServices() {
        // Auth Network Service
        DependencyInjector.register(
            NetworkService<AuthEndpoint>(),
            key: .auth
        )
    }
    
    static func registerDataSources() {
        // Auth Data Source
        DependencyInjector.register(AuthRemoteDataSource() as any AuthDataSourceProtocol)
    }
    
    static func registerRepositories() {
        DependencyInjector.register(AuthRepository() as any AuthRepositoryProtocol)
    }
    
    static func registerUseCases() {
        DependencyInjector.register(SigninUseCase() as any SigninUseCaseProtocol)
        DependencyInjector.register(SignOutUseCase() as any SignOutUseCaseProtocol)
        DependencyInjector.register(GetUserUseCase() as any GetUserUseCaseProtocol)
    }
    
    static func registerAll() {
        registerNetworkServices()
        registerDataSources()
        registerRepositories()
        registerUseCases()
    }
}
