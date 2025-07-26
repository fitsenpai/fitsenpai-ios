//
//  WeightsRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//

import Foundation
import CoreKit

final class WeightsRepository: WeightsRepositoryProtocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: WeightsDataSourceProtocol
        
    @AppState(\.trialStartDate) private var trialStartDate
    
    func getWeights() async throws -> [WeightDataPoint] {
        return try await remoteDataSource.getWeights().map({ $0.toDomain()})
    }
    
    func createWeights(_ params: WeightRequest) async throws -> [WeightDataPoint] {
        return try await remoteDataSource.createWeights(params).map({ $0.toDomain()})
    }
    
    func getBMI(id: String) async throws -> BMIData {
        return try await remoteDataSource.getBMI(id: id).toDomain()
    }
}
