//
//  WeekGeneratorUseCase.swift
//  FitSenpai
//
//  Created by Kevin M on 12/26/24.
//

import Foundation
import Supabase

protocol WeekGeneratorUseCase {
    func execute(forUser userId: UUID) async throws -> Int?
}

class WeekGenerator: WeekGeneratorUseCase {
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func execute(forUser userId: UUID) async throws -> Int? {
        let supabaseClient = client
        let response = try await supabaseClient
            .from(FSTable.weeklyPlansTest.rawValue)
            .select("week_number")
            .eq("user_id", value: userId.uuidString)
            .order("week_number", ascending: false)
            .limit(1)
            .execute()
        
        if let jsonArray = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]],
           let maxWeekNumber = jsonArray.first?["week_number"] as? Int {
            return maxWeekNumber
        }
        
        return nil
    }
}
