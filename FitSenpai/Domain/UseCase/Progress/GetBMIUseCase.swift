//
//  GetBMIUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//

import Foundation
import CoreKit

protocol GetBMIUseCaseProtocol {
    func execute(id: String) async throws -> BMIData
}

final class GetBMIUseCase: GetBMIUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WeightsRepositoryProtocol
    
    func execute(id: String) async throws -> BMIData {
        return try await repository.getBMI(id: id)
    }
}
