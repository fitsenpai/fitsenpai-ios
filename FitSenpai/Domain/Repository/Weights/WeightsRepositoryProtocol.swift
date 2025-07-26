//
//  WeightsRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//


import Foundation

protocol WeightsRepositoryProtocol {
    func getWeights() async throws -> [WeightDataPoint]
    func createWeights(_ params: WeightRequest) async throws -> [WeightDataPoint]
    func getBMI(id: String) async throws -> BMIData
}
