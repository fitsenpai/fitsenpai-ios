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
    
    func getGroceries() async throws -> [GroceryWeek] {
        await groceriesDataStore.items.map({ $0.toDomain() })
    }
    
    func updateGrocery(_ entity: GroceryWeekEntity) async throws {
        await groceriesDataStore.updateSelectedItem(entity)
    }
}
