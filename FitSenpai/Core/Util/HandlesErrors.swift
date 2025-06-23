//
//  HandlesErrors.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/24/25.
//


import Foundation
import CoreKit

@MainActor
protocol HandlesErrors: AnyObject {
    var viewState: ViewState { get set }
    func handleError(_ error: Error, message: String)
}

extension HandlesErrors {
    func handleError(_ error: Error, message: String) {
        FSLogger.error("\(message): \(error.localizedDescription)")
        viewState = .error(error)
        
        if let networkError = error as? NetworkError {
            print("Network error: \(networkError.localizedDescription)")
            // You can now show this message to the user
        } else {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
