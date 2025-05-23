//
//  UpdateGroceryUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/18/25.
//



import Foundation
import CoreKit

protocol UpdateGroceryUseCaseProtocol {
    func execute(_ entity: GroceryWeekEntity) async throws
}

final class UpdateGroceryUseCase: UpdateGroceryUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var repository: GroceryRepositoryProtocol
    
    func execute(_ entity: GroceryWeekEntity) async throws {
        return try await repository.updateGrocery(entity)
    }
}
