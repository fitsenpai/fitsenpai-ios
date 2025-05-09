//
//  WorkoutPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//


//
//  WorkoutDemoUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation
import CoreKit

protocol WorkoutPlanUseCaseProtocol {
    func execute() async throws -> WorkoutPlan?
}

final class WorkoutPlanUseCase: WorkoutPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute() async throws -> WorkoutPlan? {
        return try await repository.getWorkoutPlan()
    }
}
