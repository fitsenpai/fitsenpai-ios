//
//  GroceryRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//


import Foundation

protocol GroceryRepositoryProtocol {
    func getGroceries() async throws -> [GroceryWeek]
    func updateGrocery(_ entity: GroceryWeekEntity) async throws
    func toggleGroceryItem(_ params: GroceryToggleParams) async throws 
}
