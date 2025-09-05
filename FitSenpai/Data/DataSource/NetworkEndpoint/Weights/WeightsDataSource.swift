//
//  UserDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol WeightsDataSourceProtocol {
    func getWeights() async throws -> [WeightsDTO]
    func createWeights(_ params: WeightRequest) async throws -> [WeightsDTO]
    func getBMI(id: String) async throws -> BmiDTO
    func getBMIDemo(_ params: BMIRequest) async throws -> BmiDTO
}

final class WeightsDataSource: WeightsDataSourceProtocol {
   
    // MARK: - Dependencies
    @Inject(key: "weights")
    private var networkService: NetworkService<WeightsEndpoint>
    
    // MARK: - Auth API Calls
    
    func getWeights() async throws -> [WeightsDTO] {
        return try await networkService.request(.getWeights)
    }
    
    func createWeights(_ params: WeightRequest) async throws -> [WeightsDTO] {
        return try await networkService.request(.createWeights(params))
    }
    
    func getBMI(id: String) async throws -> BmiDTO {
        return try await networkService.request(.getBMI(id: id))
    }
    
    func getBMIDemo(_ params: BMIRequest) async throws -> BmiDTO {
        return try await networkService.request(.getBMIDemo(params))
    }
}
