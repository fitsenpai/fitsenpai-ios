//
//  GroceryDataSourceProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//


import Foundation
import CoreKit

protocol GroceryDataSourceProtocol {
    func getGroceriesPlan() async throws -> GroceryPlanResponse?
    func toggleGroceryItem(_ params: GroceryToggleParams) async throws
}

final class GroceryDataSource: GroceryDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "grocery")
    private var networkService: NetworkService<GroceryEndpoint>
    
    // MARK: - API Calls
    
    func getGroceriesPlan() async throws -> GroceryPlanResponse? {
        return try await networkService.request(.getGroceries)
    }
    
    func toggleGroceryItem(_ params: GroceryToggleParams) async throws {
        return try await networkService.request(.groceryToggleCompleted(params))
    }
}
