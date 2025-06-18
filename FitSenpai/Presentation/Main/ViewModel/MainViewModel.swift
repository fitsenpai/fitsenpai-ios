//
//  MainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import CoreKit

// MARK: - ViewModel
@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var selectedTab: MainTab = .workouts
    @Published var activeSheet: MainViewSheet?
}
