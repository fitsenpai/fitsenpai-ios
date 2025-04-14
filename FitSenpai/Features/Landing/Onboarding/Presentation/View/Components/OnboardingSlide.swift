//
//  OnboardingSlide.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import Foundation
import SwiftUI

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
    
    static let slides: [OnboardingSlide] = [
        OnboardingSlide(
            image: "carousel_1",
            title: "Workouts made\njust for you",
            subtitle: "Tailored routines based on your\npreferences and fitness level."
        ),
        OnboardingSlide(
            image: "carousel_2",
            title: "Easy-to-follow meals\nwith macros",
            subtitle: "Nutrition guides and macro targets\ndesigned to fuel your progress."
        ),
        OnboardingSlide(
            image: "carousel_3",
            title: "Grocery shopping\nmade easy",
            subtitle: "Auto-generated shopping lists to match\nyour meal plan effortlessly."
        )
    ]
}
