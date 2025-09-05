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
    @Inject private var profileStore: ProfileDataStore

    @AppState(\.trialStartDate) private var trialStartDate
    
    func getWeights() async throws -> [WeightDataPoint] {
        return try await remoteDataSource.getWeights().map({ $0.toDomain()})
    }
    
    func createWeights(_ params: WeightRequest) async throws -> [WeightDataPoint] {
        return try await remoteDataSource.createWeights(params).map({ $0.toDomain()})
    }
    
    func getBMI(id: String) async throws -> BMIData {
        if trialStartDate != nil {
            let profile = profileStore.getCurrentProfile()
            if let height = profile?.height, let weight = profile?.weight {
                return try await remoteDataSource.getBMIDemo(.init(height_cm: Double(height), weight_kg: Double(weight))).toDomain()
            } else {
                return BMIData(bmi: 0.0, status: "Normal")
            }
        } else {
            return try await remoteDataSource.getBMI(id: id).toDomain()
        }
    }
}
