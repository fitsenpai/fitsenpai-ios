//
//  ViewState.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

/// Represents different states of a view.
enum ViewState: Equatable {
    case idle
    case loading
    case updating
    case fetching
    case uploading
    case error(Error)
    
    /// Compares two `ViewState` instances for equality.
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.updating, .updating),
             (.fetching, .fetching),
             (.uploading, .uploading):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return isEqual(lhsError, rhsError)
        default:
            return false
        }
    }
    
    /// Compares two `Error` instances based on their localized descriptions.
    private static func isEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
