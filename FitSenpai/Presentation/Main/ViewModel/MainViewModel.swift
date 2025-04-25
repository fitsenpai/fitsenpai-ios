//
//  MainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import CoreKit

// MARK: - ViewModel
final class MainViewModel: ObservableObject {
    
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    
    // MARK: - Properties
    @Published var activeSheet: MainViewSheet?
    @Published var selectedDate: Date = Date()
    @Published var currentWeekStartDate: Date = Date()
    @Published var selectedTab: MainTab = .workouts
    @Published var progressData: [Date: Double] = [:]
    @Published var highlightedDays: Set<Int> = []
    @Published var currentWeekOffset: Int = 0
    @Published var profile: FitnessProfile?
    
    // MARK: - Initialization
    init() {
        self.initializeData()
    }
    
    func initializeData() {
        Task { @MainActor in
            await getUserProfile()
        }
    }
    
    func updateCurrentWeekStartDate(to date: Date) {
        triggerHaptics()
    }
    
    func getUserProfile() async {
        do {
            self.profile = try await self.getUserProfileUseCase.execute()
        } catch {
            print(error)
        }
    }
}
