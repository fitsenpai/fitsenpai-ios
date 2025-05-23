//
//  GroceryPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//


import Foundation
import CoreKit

protocol GroceryPlanUseCaseProtocol {
    func execute() async throws -> [GroceryWeek]
}

final class GroceryPlanUseCase: GroceryPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: GroceryRepositoryProtocol
    
    func execute() async throws -> [GroceryWeek] {
        return try await repository.getGroceries()
    }
}
