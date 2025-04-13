//
//  NotificationsStepView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct NotificationsStepView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    @State private var arrowOffset: CGFloat = 40
    
    private let title = "Reach your goals with notifications"
    private let popupTitle = "Fit Senpai would like to\nsend you notifications"
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            FSTextView(title, typography: .h2, alignment: .center)
            notificationModelView
            Spacer()
                .frame(height: 50)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    var notificationModelView: some View {
        VStack(spacing: 0) {
            FSTextView(popupTitle, typography: .p_ui_medium, alignment: .center)
            .padding(24)
        
            Divider()
                .frame(height: 1)
                .padding(0)
            
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    Button(action: {
                        viewModel.triggerHaptics()
                        withAnimation {
                            viewModel.moveToNextStep()
                        }
                    }) {
                        FSText(text: "Don't Allow",
                              fontStyle: .body14)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        viewModel.requestNotificationPermission()
                    }) {
                        FSText(text: "Allow",
                              fontStyle: .body14,
                              color: .white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedCorner(radius: 16, corners: [.bottomRight])
                                    .fill(Color.black)
                            )
                    }
                    .overlay(alignment: .bottom) {
                        Text("👆")
                            .font(.title)
                            .foregroundColor(.black)
                            .offset(x: 0, y: arrowOffset)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                    arrowOffset = 50
                                }
                            }
                        
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray246)
        )
        .frame(width: 243)
    }
}

#Preview {
    NotificationsStepView(viewModel: .init())
}
