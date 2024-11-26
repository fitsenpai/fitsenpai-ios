//
//  TestimonialView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct TestimonialView: View {
    @ObservedObject var viewModel: TestimonialViewModel
    
    var nameAndRating: some View {
        HStack{
            FSText(text: viewModel.title, fontStyle: .subHeaderRegular, color: .white)
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<viewModel.rating, id: \.self) { _ in
                    Image("ic_star")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
    
    var imageAndTitle: some View {
        HStack(spacing: 16) {
            Image(viewModel.image)
            VStack(alignment: .leading, spacing: 4) {
                nameAndRating
                FSText(text: viewModel.subtitle, fontStyle: .subHeaderRegular, color: .gray156)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            imageAndTitle
                .frame(height: 56)
            FSText(text: viewModel.description, fontStyle: .body14, letterSpace: 1, color: .white, lineSpacing: 5)
        }
        .padding(20)
        .background {
            RoundedCornerShape(corners: [.allCorners], radius: 16)
                .fill(Color.deepBlackBackground)
                .frame(maxHeight: .infinity)
        }
        
    }
}

// Custom modifier to round specific corners in SwiftUI
struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    TestimonialView(viewModel: TestimonialViewModel(testimonial: Testimonial.initDummy()))
}
