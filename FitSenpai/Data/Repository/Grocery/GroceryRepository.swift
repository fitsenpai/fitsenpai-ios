//
//  GroceryRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//

import Foundation
import CoreKit

final class GroceryRepository: GroceryRepositoryProtocol {
   
    // MARK: - Dependencies
    @Inject private var remoteDataSource: GroceryDataSourceProtocol
    @Inject private var groceriesDataStore: GroceriesDataStore
    
    @AppState(\.trialStartDate) private var trialStartDate

    func getGroceries() async throws -> [GroceryWeek] {
        if trialStartDate != nil {
            return groceriesDataStore.items.map({ $0.toDomain() })
        } else {
            let response = try await remoteDataSource.getGroceriesPlan()
            groceriesDataStore.deleteAll()
            let domainPlan = response?.plan.map({ plan in
                return plan.toDomain()
            }) ?? []
            
            if !domainPlan.isEmpty {
                groceriesDataStore.addBatch(domainPlan.map({ $0.toEntity() }))
            }
            
            return domainPlan
        }
    }
    
    func updateGrocery(_ entity: GroceryWeekEntity) async throws {
        groceriesDataStore.updateSelectedItem(entity)
    }
}
