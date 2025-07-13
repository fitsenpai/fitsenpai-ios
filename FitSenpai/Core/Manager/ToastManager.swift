//
//  ToastManager.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//


import SwiftUI
import Combine

class ToastManager: ObservableObject {
    @Published var currentToast: ToastMessage?
    private var cancellables = Set<AnyCancellable>()
    private var dismissTimer: AnyCancellable?
    
    static let shared = ToastManager()
    
    private init() {}
    
    func showToast(_ message: String, type: ToastType = .info, duration: TimeInterval = 3.0) {
        let toast = ToastMessage(message: message, type: type, duration: duration)
        
        // Cancel any existing timer
        dismissTimer?.cancel()
        dismissTimer = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentToast = toast
        }
        
        // Auto-dismiss after specified duration
        dismissTimer = Timer.publish(every: duration, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { _ in
                self.dismissToast()
            }
    }
    
    func showError(_ message: String, duration: TimeInterval = 10.0) {
        showToast(message, type: .error, duration: duration)
    }
    
    func showSuccess(_ message: String, duration: TimeInterval = 5.0) {
        showToast(message, type: .success, duration: duration)
    }
    
    func dismissToast() {
        // Cancel the timer when manually dismissing
        dismissTimer?.cancel()
        dismissTimer = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentToast = nil
        }
    }
}

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    let duration: TimeInterval
    
    init(message: String, type: ToastType, duration: TimeInterval = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
    }
    
    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool {
        lhs.id == rhs.id
    }
}

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}
