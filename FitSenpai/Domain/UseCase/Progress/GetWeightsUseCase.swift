//
//  GetWeightsUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//


import Foundation
import CoreKit

protocol GetWeightsUseCaseProtocol {
    func execute() async throws -> [WeightDataPoint]
}

final class GetWeigthsUseCase: GetWeightsUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WeightsRepositoryProtocol
    
    func execute() async throws -> [WeightDataPoint] {
        return try await repository.getWeights()
    }
}
