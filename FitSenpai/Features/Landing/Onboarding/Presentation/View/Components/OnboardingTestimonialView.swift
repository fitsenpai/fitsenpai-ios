//
//  OnboardingTestimonialView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct OnboardingTestimonialView: View {
    let testimony = "I started in 2023 and have already lost 15% body fat! I didn't need to hire a trainer or spend all day figuring out what to eat."
    let author: String = "- Czarina V."
    let image: String = "testimonial_image"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ForEach(0..<5) { _ in
                    Image(.star)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                Spacer()
            }
            
            FSTextView(testimony, font: .italic, typography: .p_ui)
            
            FSTextView(author, typography: .body_medium, color: .gray)
            
            Image("testimonial_image")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .padding(.vertical, 6)
        }
    }
}
