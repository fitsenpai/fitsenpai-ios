//
//  OnboardingViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {
    
    @Published private(set) var currentPage = 0
    @Published private(set) var slideDirection: Edge = .trailing
    private var timer: AnyCancellable?
    private let timerInterval: TimeInterval = 5.0
    
    func startAutoScroll() {
        setupTimer()
    }
    
    func stopAutoScroll() {
        cancelTimer()
    }
    
    private func setupTimer() {
        // Cancel any existing timer before creating a new one
        cancelTimer()
        
        timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.moveToNextPage()
            }
    }
    
    private func cancelTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func moveToNextPage() {
        slideDirection = .trailing
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPage < OnboardingSlide.slides.count - 1 {
                currentPage += 1
            } else {
                currentPage = 0
            }
        }
        setupTimer()
    }
    
    func moveToPreviousPage() {
        slideDirection = .leading
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPage > 0 {
                currentPage -= 1
            } else {
                currentPage = OnboardingSlide.slides.count - 1
            }
        }
        setupTimer()
    }
}
