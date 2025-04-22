//
//  Testimonial.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation

class Testimonial {
    var image: String
    var title: String
    var subtitle: String
    var description: String
    var rating: Int
    
    init(image: String, title: String, subtitle: String, description: String, rating: Int) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.rating = rating
    }
    
    
    static func initDummy() -> Testimonial {
        return Testimonial(image: "img_dummy_prof_1", title: "Ina V.", subtitle: "Lost 9% Body Fat", description: "Fit Senpai has made me more confident and independent at the gym. The personalized workout and meal plans work like magic. Highly recommended!", rating: 5)
    }
}
