//
//  OnboardingView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var appState: AppViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // MARK: - Image Section
                    carouselImageSection
                        .frame(height: geometry.size.height * 0.6)
                    
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.55) // Overlap point
                        
                        // MARK: - Content Section with rounded top corners
                        VStack(spacing: 12) {
                            contentSection
                            Divider()
                            // MARK: - Action Buttons
                            actionButtonsSection
                        }
                        .background(
                            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                        )
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color.white)
            }
            .onDisappear(perform: viewModel.stopAutoScroll)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        handleSwipe(translation: value.translation.width)
                    }
            )
            .navigationDestination(item: $viewModel.navDestination, destination: { view in
                switch view {
                case .signin:
                    let client = FSClient.shared!
                    let loginUseCase = LoginUseCase(client: client)
                    let viewModel = LoginViewModel(loginUseCase: loginUseCase)

                    LoginView(viewModel: viewModel)
                case .createPlan:
                    OnboardingMainView()
                }
        
            })
        }
    }
    
    private var carouselImageSection: some View {
        ZStack {
            if let currentSlide = OnboardingSlide.slides[safe: viewModel.currentPage] {
                Image(currentSlide.image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.1)),
                            removal: .opacity.combined(with: .scale(scale: 0.9))
                        )
                    )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: viewModel.moveToNextPage)
    }
    
    private var contentSection: some View {
        VStack(spacing: 24) {
            if let currentSlide = OnboardingSlide.slides[safe: viewModel.currentPage] {
                slideContent(currentSlide)
            }
            Spacer()
            pageIndicators
        }
        .padding(.top, 32)
        .contentShape(Rectangle())
        .onTapGesture(perform: viewModel.moveToNextPage)
    }
    
    private func slideContent(_ slide: OnboardingSlide) -> some View {
        VStack(spacing: 16) {
            FSText(
                text: slide.title,
                fontStyle: .heading28,
                letterSpace: 0,
                lineSpacing: 4,
                alignment: .center
            )
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
            .id("title\(viewModel.currentPage)")
            
            FSText(
                text: slide.subtitle,
                fontStyle: .body16,
                letterSpace: 0,
                lineSpacing: 4,
                alignment: .center
            )
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
            .id("subtitle\(viewModel.currentPage)")
        }
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<OnboardingSlide.slides.count, id: \.self) { index in
                Circle()
                    .fill(viewModel.currentPage == index ? Color.black : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.currentPage)
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            FSButton(
                title: "Create my plan",
                fontStyle: .bodyBold16,
                letterSpace: 0,
                cornerRadius: 32
            ) {
                viewModel.handleCreatePlan()
            }
            
            FSButton(
                title: "I already have an account",
                letterSpace: 0,
                cornerRadius: 32,
                background: .gray246
            ) {
                viewModel.handleExistingAccount()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .padding(.bottom, 24)
    }
    
    private func handleSwipe(translation: CGFloat) {
        let threshold: CGFloat = 50
        if translation > threshold {
            viewModel.moveToPreviousPage()
        } else if translation < -threshold {
            viewModel.moveToNextPage()
        }
    }
}

// MARK: - Extensions
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
