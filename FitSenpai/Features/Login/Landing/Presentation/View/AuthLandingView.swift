//
//  AuthLandingView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct AuthLandingView: View {
    @State private var navigateToLogin = false
    
    var swipeableTestimonialView: some View {
        TabView() {
            ForEach(0..<5) { _ in
                TestimonialView(viewModel: TestimonialViewModel(testimonial: Testimonial.initDummy()))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 280)
        .onAppear(perform: {
            setupAppearance()
        })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackBackground
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    VStack(spacing: 100) {
                        VStack {
                            Image("img_full_logo")
                                .resizable()
                                .frame(width: 240, height: 32)
                            
                            swipeableTestimonialView
                            
                        }
                        VStack(spacing: 16) {
                            FSButtonLight(title: "Sign up", tapAction: {})
                            FSButton(title: "Login", tapAction: {
                                print("navigate")
                                navigateToLogin = true
                            })
                        }
                        
                    }
                    .padding(16)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                let client = FSClient.shared!
                let loginUseCase = LoginUseCase(client: client)
                let viewModel = LoginViewModel(loginUseCase: loginUseCase)

                LoginView(viewModel: viewModel)
            }
        }
        
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = FSColor.primary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
}

#Preview {
    AuthLandingView()
}
