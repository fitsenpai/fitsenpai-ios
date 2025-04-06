//
//  SubscriptionViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

// MARK: - ViewModel
final class SubscriptionViewModel: ObservableObject {
    @Published var selectedPlan: SubscriptionPlan = .annual
    @Published var currentPage = 1
    @State var showSafariView = false
    @State var safariURL: URL?
    
    private let termsURL = "https://www.fitsenpai.com/terms"
    private let privacyURL = "https://www.fitsenpai.com/privacy-policy"
    
    var currentPageMessage: String {
        switch currentPage {
        case 1,2: return "No payment due now"
        case 3: return "Pay once. Access forever."
        case 4: return "No commitment. Cancel anytime."
        default: return "Pay once. Access forever."
        }
    }
    
    let plans: [PlanItem] = [
        .init(type: .monthly, price: "$10", period: "/mo"),
        .init(type: .annual, price: "$5", period: "/mo", subtitle: "billed annually", isPopular: true),
        .init(type: .lifetime, price: "$99", period: "", subtitle: "one-time payment", originalPrice: "$249")
    ]
    
    let subscriptionPages: [SubscriptionPageData] = [
        .init(title: "7 days free, then\njust $10 per month",
              items: [("icon_calendar", "Today", "Get full access to workouts, meal plans,\nand your grocery list with Fit Senpai."),
                      ("icon_bell_ring", "In 4 days", "We'll send you a reminder that your trial is\nending soon."),
                      ("icon_crown", "In 7 days", "You'll be charged on {(date)} unless you\ncancel anytime before.")]),
        .init(title: "7 days free, then\njust $60 per year",
              items: [("icon_calendar", "Today", "Get full access to workouts, meal plans,\nand your grocery list with Fit Senpai."),
                      ("icon_bell_ring", "In 4 days", "We'll send you a reminder that your trial is\nending soon."),
                      ("icon_crown", "In 7 days", "You'll be charged on {(date)} unless you\ncancel anytime before.")]),
        .init(title: "One-time payment for\nlifetime access",
              items: [("icon_barbell", "Personalized workouts", "Tailored plans that fit your goals, schedule,\nand fitness level."),
                      ("icon_fork_knife", "Smart meal planning", "Simple meal guides with grocery lists for\neasy, sustainable eating."),
                      ("icon_lightning", "Stay on track effortlessly", "Daily reminders and easy-to-follow plans\nkeep you consistent.")]),
        .init(title: "Limited Time Deal",
              subtitle: "You will never see this again",
              isPromotional: true)
    ]
    
    func handleSubscription() {
        // Handle subscription logic
    }
    
    func handleTerms() {
        safariURL = URL(string: termsURL)
        showSafariView = true
    }
    
    func handleRestore() {
        // Handle restore purchase
    }
    
    func handlePrivacy() {
        // Handle privacy
    }
}
