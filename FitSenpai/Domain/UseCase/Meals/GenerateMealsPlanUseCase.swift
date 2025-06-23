//
//  GenerateMealsPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation
import CoreKit

protocol GenerateMealsPlanUseCaseProtocol {
    func execute(date: String) async throws
}

final class GenerateMealsPlanUseCase: GenerateMealsPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: MealsRepositoryProtocol
    
    func execute(date: String) async throws  {
        try await repository.generateMealPlan(.init(date: date))
    }
}
