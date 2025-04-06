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
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            FSText(text: "Reach your goals with notifications",
                   fontStyle: .heading28, alignment: .center)
            
            VStack(spacing: 0) {
                FSText(text: "Fit Senpai would like to send you notifications",
                       fontStyle: .body14, alignment: .center)
                .padding(24)
            
                Divider()
                    .frame(height: 1)
                    .padding(0)
                
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                viewModel.moveToNextStep()
                            }
                        }) {
                            FSText(text: "Don't Allow",
                                  fontStyle: .body14,
                                  color: .gray)
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
            .frame(width: 300)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    NotificationsStepView(viewModel: .init())
}
