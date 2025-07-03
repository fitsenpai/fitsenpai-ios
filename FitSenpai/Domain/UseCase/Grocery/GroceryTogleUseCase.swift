//
//  GroceryTogleUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//


import Foundation
import CoreKit

protocol GroceryTogleUseCaseProtocol {
    func execute(_ params: GroceryToggleParams) async throws
}

final class GroceryTogleUseCase: GroceryTogleUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var repository: GroceryRepositoryProtocol
    
    func execute(_ params: GroceryToggleParams) async throws {
        return try await repository.toggleGroceryItem(params)
    }
}
