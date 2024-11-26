//
//  TestimonialViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

class TestimonialViewModel: ObservableObject {
    @Published var image: String
    @Published var title: String
    @Published var subtitle: String
    @Published var description: String
    @Published var rating: Int
    
    init(testimonial: Testimonial) {
        self.image = testimonial.image
        self.title = testimonial.title
        self.subtitle = testimonial.subtitle
        self.description = testimonial.description
        self.rating = testimonial.rating
    }
    
}
