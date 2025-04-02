//
//  OnboardingTestimonialView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct OnboardingTestimonialView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(0..<5) { _ in
                    Image(.star)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                Spacer()
            }
            
            FSText(
                text: "I started in 2023 and have already lost 15% body fat! I didn't need to hire a trainer or spend all day figuring out what to eat.\n\n- Corina V.",
                fontStyle: .italic16
            )
            
            Image("testimonial_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            
            Spacer()
            
        }
    }
}
