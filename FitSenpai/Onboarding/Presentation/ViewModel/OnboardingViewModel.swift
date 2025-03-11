//
//  OnboardingViewModel.swift
//  FitSenpai
//
//  Created by Kevin M on 3/11/25.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    
    @Published var selectedGender: FSSignUpItem?
    @Published var selectedDailyActivityLevel: FSSignUpItem?
    @Published var selectedPastTraining: FSSignUpItem?
    @Published var selectedMainGoal: FSSignUpItem?
    @Published var selectedStoppingYouFromLivingHealthier: FSSignUpItem?
    @Published var selectedWouldLikeToAccomplish: FSSignUpItem?
    @Published var selectedWorkoutExperience: FSSignUpItem?
    @Published var selectedWorkoutLocation: FSSignUpItem?
    @Published var selectedWorkoutDay: FSSignUpItem?
    @Published var selectedWorkoutDuration: FSSignUpItem?
    @Published var selectedHealthRestriction: FSSignUpItem?
    @Published var selectedDietPreference: FSSignUpItem?
    @Published var selectedFoodAllergy: FSSignUpItem?
    @Published var selectedEatingHabit: FSSignUpItem?
    
    
    let genderSelections: [FSSignUpItem] = [FSSignUpItem(title: "Male"), FSSignUpItem(title: "Female"), FSSignUpItem(title: "Other")]
    let dailyActivitySelections: [FSSignUpItem] = [
        FSSignUpItem(title: "Sedentary", subtitle: "Mostly sitting, little exercise", iconName: "ic_chair"),
        FSSignUpItem(title: "Light activity", subtitle: "1-2 workouts/week", iconName: "ic_jog"),
        FSSignUpItem(title: "Moderate", subtitle: "3-5 workouts/week", iconName: "ic_bike"),
        FSSignUpItem(title: "Heavy training", subtitle: "6-7 workouts/week", iconName: "ic_duble"),
        FSSignUpItem(title: "Athlete", subtitle: "Training 2x per day", iconName: "ic_swim")
    ]
    let pastTrainingSelections: [FSSignUpItem] = [
        FSSignUpItem(title: "Personal trainers", iconName: "ic_handshake"),
        FSSignUpItem(title: "Fitness apps", iconName: "ic_phone"),
        FSSignUpItem(title: "Workout videos", iconName: "ic_play_workout"),
        FSSignUpItem(title: "Meal plans or diet programs", iconName: "ic_spoon_fork"),
        FSSignUpItem(title: "None", iconName: "ic_cross")
    ]
    let mainGoalSelections: [FSSignUpItem] = [FSSignUpItem(title: "Fat loss"), FSSignUpItem(title: "Muscle gain"), FSSignUpItem(title: "General fitness"),FSSignUpItem(title: "Increased endurance"),FSSignUpItem(title: "Aesthetic")]
    let stoppingFromLivingHealthierSelections: [FSSignUpItem] = [FSSignUpItem(title: "Personal trainers", iconName: "ic_handshake"),
                                                                 FSSignUpItem(title: "Lack of consistency", iconName: "ic_bar_chart"),
                                                                 FSSignUpItem(title: "Unhealthy eating habits", iconName: "ic_burger"),
                                                                 FSSignUpItem(title: "Fitness is too expensive", iconName: "ic_dollar"),
                                                                 FSSignUpItem(title: "Busy schedule", iconName: "ic_calendar"),FSSignUpItem(title: "Not sure where to start", iconName: "ic_frown")]
    let wouldLikeToAccomplishSelections: [FSSignUpItem] = [FSSignUpItem(title: "Stay motivated and consistent", iconName: "ic_line_chart"),
                                                                 FSSignUpItem(title: "Eat and live healthier", iconName: "ic_carrot_2"),
                                                                 FSSignUpItem(title: "Save money while getting fit", iconName: "ic_piggy"),
                                                                 FSSignUpItem(title: "Boost my energy and mood", iconName: "ic_sun"),
                                                                 FSSignUpItem(title: "Feel better about my body", iconName: "ic_parent")]
    
    let workoutExperienceSelections: [FSSignUpItem] = [
        FSSignUpItem(title: "Beginner", subtitle: "I’m new to fitness", iconName: "ic_jog"),
        FSSignUpItem(title: "Intermediate", subtitle: "I workout from time to time", iconName: "ic_duble"),
        FSSignUpItem(title: "Advanced", subtitle: "I exercise regularly", iconName: "ic_lightning")
    ]
    let workoutLocationSelections: [FSSignUpItem] = [
        FSSignUpItem(title: "Home", subtitle: "Bodyweight exercises with little or no equipment", iconName: "ic_house"),
        FSSignUpItem(title: "Gym", subtitle: "Machine and free-weight exercises", iconName: "ic_duble"),
        FSSignUpItem(title: "Mixed", subtitle: "Combination of home and gym workouts", iconName: "ic_arrows")
    ]
    let workoutDaySelections: [FSSignUpItem] = [FSSignUpItem(title: "Sunday"), FSSignUpItem(title: "Monday"), FSSignUpItem(title: "Tuesday"),FSSignUpItem(title: "Wednesday"),FSSignUpItem(title: "Thursday"),FSSignUpItem(title: "Friday"),FSSignUpItem(title: "Saturday")]
    let workoutDurationSelections: [FSSignUpItem] = [FSSignUpItem(title: "15 mins"), FSSignUpItem(title: "30 mins"), FSSignUpItem(title: "60 mins"),FSSignUpItem(title: "Other")]
    let healthRestrictionSelections: [FSSignUpItem] = [FSSignUpItem(title: "None", iconName: "ic_cross"),
                                                                 FSSignUpItem(title: "Joint pain", iconName: "ic_bone"),
                                                                 FSSignUpItem(title: "Back issues", iconName: "ic_back_part"),
                                                                 FSSignUpItem(title: "Heart condition", iconName: "ic_heart_2"),
                                                                 FSSignUpItem(title: "Other", iconName: "ic_dots")]
    let specificDietSelections: [FSSignUpItem] = [FSSignUpItem(title: "None", iconName: "ic_cross"),
                                                                 FSSignUpItem(title: "High protein, low carb", iconName: "ic_bone_whole"),
                                                                 FSSignUpItem(title: "Vegetarian", iconName: "ic_orange"),
                                                                 FSSignUpItem(title: "Vegan", iconName: "ic_leaves"),
                                                                 FSSignUpItem(title: "Other", iconName: "ic_dots")]
    let foodAllergySelections: [FSSignUpItem] = [FSSignUpItem(title: "None", iconName: "ic_cross"),
                                                                 FSSignUpItem(title: "Nuts", iconName: "ic_nuts"),
                                                                 FSSignUpItem(title: "Milk and dairy", iconName: "ic_cheese"),
                                                                 FSSignUpItem(title: "Shellfish", iconName: "ic_shrimp"),
                                                                 FSSignUpItem(title: "Other", iconName: "ic_dots")]
    let eatingHabitsSelections: [FSSignUpItem] = [FSSignUpItem(title: "I cook most of my meals"), FSSignUpItem(title: "I order meal plans"), FSSignUpItem(title: "I eat out often"),FSSignUpItem(title: "I mix between cooking and ordering")]
    
}
