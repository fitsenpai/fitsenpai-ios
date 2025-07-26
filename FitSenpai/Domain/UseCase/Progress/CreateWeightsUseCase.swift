//
//  CreateWeightsUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//


import Foundation
import CoreKit

protocol CreateWeightsUseCaseProtocol {
    func execute(_ params: WeightsData) async throws -> [WeightDataPoint]
}

final class CreateWeigthsUseCase: CreateWeightsUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WeightsRepositoryProtocol

    func execute(_ params: WeightsData) async throws -> [WeightDataPoint] {
        return try await repository.createWeights(.init(weight: params.weight, date: params.date))
    }
}
