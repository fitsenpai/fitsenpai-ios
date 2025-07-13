//
//  SettingsMainView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/9/25.
//

import SwiftUI
import Combine
import StoreKit
import SwiftData
import CoreKit

struct SettingsMainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var superwall: SuperwallManager
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var showSafariView = false
    @State private var safariURL: URL?
    @State private var isPresentedManageSubscription: Bool = false
    
    // URLs
    private let supportEmail = "support@fitsenpai.com"
    private let termsURL = "https://www.fitsenpai.com/terms"
    private let privacyURL = "https://www.fitsenpai.com/privacy-policy"
    private let showDebugMenu = false
    
    init() { }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                FSTextView("Settings", typography: .h3)
                    .padding(.top, 32)
                
                if viewModel.viewState == .loading {
                    ShimmerSettingsView()
                } else {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 4) {
                            sectionHeader("PROFILE")
                            VStack(alignment: .leading, spacing: 12) {
                                profileHeader
                                profileSection
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sectionHeader("PREFERENCES")
                            preferencesSection
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sectionHeader("RESTRICTIONS")
                            restrictionsSection
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sectionHeader("SUPPORT & LEGAL")
                            supportSection
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sectionHeader("ACCOUNT")
                            accountSection
                        }
                        
                        if superwall.canLogout {
                            deleteAccountButton
                                .padding(.bottom, 24)
                        }
                        
                        // MARK: Debug menu
                        if !appViewModel.isProduction {
                            debugMenuSection
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .manageSubscriptionsSheet(isPresented: $isPresentedManageSubscription)
            .fullScreenCover(item: $viewModel.activePopup, content: { popup in
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            triggerHaptics()
                            viewModel.activeSheet = nil
                        }
                    switch popup {
                    case .rating:
                        RateAppPopupView {
                            triggerHaptics()
                            viewModel.activeSheet = .negative
                        }
                    case .logout:
                        LogoutPopupView {
                            triggerHaptics()
                            Task {
                                let success = await viewModel.signOut()
                                if success {
                                    appViewModel.authState = .unauthenticated
                                    superwall.resetUser()
                                    try? modelContext.delete(model: UserProfileEntity.self)
                                    try? modelContext.delete(model: WorkoutWeekEntity.self)
                                    try? modelContext.delete(model: MealsWeekEntity.self)
                                    try? modelContext.delete(model: GroceryWeekEntity.self)
                                }
                            }
                        }
                    }
                }
                .background(BackgroundClearView())
            })
        }
        .environmentObject(viewModel)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    triggerHaptics()
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
        //        .reducedWhiteLoadingOverlay(state: $viewModel.viewState)
        .sheet(isPresented: $showSafariView) {
            if let url = safariURL {
                SafariView(url: url)
            }
        }
    }
    
    private var profileHeader: some View {
        FSCard(borderColor: .gray230) {
            HStack(alignment: .center, spacing: 16) {
                Image(superwall.canLogout ? .avatarPlaceholder : .avatarPlaceholder)
                    .resizable()
                    .frame(width: 75, height: 75)
                    .overlay(alignment: .bottomTrailing) {
                        ZStack {
                            Circle()
                                .fill(Color.gray246)
                                .frame(width: 26)
                                .shadow(color: .gray230, radius: 1, x: 1, y: 1)
                            Image(systemName: "camera")
                                .font(.system(size: 12))
                                .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                
                VStack(alignment: .leading, spacing: 8) {
                    if superwall.canLogout {
                        FSPill(text: "PRO", color: .fsPrimary)
                    } else {
                        FSPill(text: "GUEST", color: .fsMutedForeground)
                    }
                    
                    FSTextView(viewModel.user?.email ?? "Anonymous user", typography: .p_ui_medium, color: .fsMutedForeground)
                }
            }
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        FSTextView(title, typography: .suble_semibold, color: .fsMutedForeground)
            .padding(.vertical, 8)
    }
    
    private var profileSection: some View {
        VStack(spacing: 0) {
            settingsRow("Age", value: "\(String(describing: Int(viewModel.profile.birthYear ?? "0") ?? 0))")
            Divider()
            settingsRow("Gender", value: viewModel.getTitle(for: \.gender, as: Gender.self))
            Divider()
            settingsRow("Height & Weight", value: viewModel.formattedHeightWeight)
            Divider()
            settingsRow("Fitness goal", value: viewModel.getTitle(for: \.mainGoal, as: MainGoalType.self))
            Divider()
            settingsRow("Activity level", value: viewModel.getTitle(for: \.activityLevel, as: ActivityLevel.self))
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var preferencesSection: some View {
        VStack(spacing: 0) {
            settingsRow("Workout location", value: viewModel.getTitle(for: \.workoutLocation, as: WorkoutLocationType.self))
            Divider()
            settingsRow("Workout days", value: formatWorkoutDays(viewModel.profile.workoutDays))
            Divider()
            settingsRow("Workout duration", value: viewModel.getTitle(for: \.workoutDuration, as: WorkoutDurationType.self))
            Divider()
            settingsRow("Difficulty level", value: viewModel.getTitle(for: \.workoutExperience, as: WorkoutExperienceType.self))
            Divider()
            settingsRow("Dietary", value: viewModel.displayDietaryPreference)
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var restrictionsSection: some View {
        VStack(spacing: 0) {
            settingsRow("Allergies", value: viewModel.displayAllergies)
            Divider()
            settingsRow("Health concerns", value: viewModel.displayHealthConcerns)
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            // Contact Support
            Button {
                triggerHaptics()
                URLHelper.openMail(to: supportEmail)
            } label: {
                settingsLinkLabel("Contact support")
            }
            Divider()
            
            // Terms & Conditions
            Button {
                safariURL = URL(string: termsURL)
                showSafariView = true
                triggerHaptics()
            } label: {
                settingsLinkLabel("Terms & conditions")
            }
            Divider()
            
            // Privacy Policy
            Button {
                safariURL = URL(string: privacyURL)
                showSafariView = true
                triggerHaptics()
            } label: {
                settingsLinkLabel("Privacy policy")
            }
            Divider()
            
            // Rate the app
            rateAppRow
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var rateAppRow: some View {
        HStack {
            FSTextView("Give feedback", typography: .p_ui_medium)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.fsMutedForeground)
                .font(.system(size: 14))
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            withoutAnimation {
                viewModel.activePopup = .rating
            }
            triggerHaptics()
        }
        .sheet(item: $viewModel.activeSheet, content: { type in
            switch type {
            case .negative:
                NegativeFeedbackSheet(feedbackType: $viewModel.activeSheet, category: "workout")
                    .flexibleSheet()
                    .background(.white)
                    .presentationCornerRadius(32)
            case .negativeInput:
                NegativeFeedbackInoutSheet(category: "workout") {
                    viewModel.activeSheet = .negativeInput
                }
                .flexibleSheet()
                .background(.white)
                .presentationCornerRadius(32)
            }
        })
    }
    
    private var accountSection: some View {
        VStack(spacing: 0) {
            Button {
                Task {
                    triggerHaptics()
                    await superwall.restore()
                }
            } label: {
                settingsLinkLabel("Restore purchase")
            }
            
            if superwall.canLogout {
                Divider()
                Button {
                    Task {
                        await MainActor.run {
                            isPresentedManageSubscription = true
                        }
                    }
                    triggerHaptics()
                } label: {
                    settingsLinkLabel("Manage subscription")
                }
                Divider()
                linkRow("Change password")
                Divider()
                Button {
                    withoutAnimation {
                        viewModel.activePopup = .logout
                    }
                    triggerHaptics()
                } label: {
                    settingsLinkLabel("Log out")
                }
            }
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var deleteAccountButton: some View {
        NavigationLink {
            DeleteAccountView()
        } label: {
            VStack(spacing: 0) {
                HStack {
                    FSTextView("Delete account", typography: .p_ui_medium, color: .red)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.fsMutedForeground)
                        .font(.system(size: 14))
                }
                .padding()
                .contentShape(Rectangle())
            }
            .background(Color.gray246)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    private func settingsRow(_ title: String, value: String?) -> some View {
        NavigationLink {
            switch title {
            case "Name":
                NameEditView(viewModel: viewModel)
            case "Age":
                AgeEditView(viewModel: viewModel)
            case "Gender":
                GenderEditView(viewModel: viewModel)
            case "Height & Weight":
                HeightWeightEditView(viewModel: viewModel)
            case "Fitness goal":
                FitnessGoalEditView(viewModel: viewModel)
            case "Activity level":
                ActivityLevelEditView(viewModel: viewModel)
            case "Workout location":
                WorkoutLocationEditView(viewModel: viewModel)
            case "Workout days":
                WorkoutDaysEditView(viewModel: viewModel)
            case "Workout duration":
                WorkoutDurationEditView(viewModel: viewModel)
            case "Difficulty level":
                DifficultyLevelEditView(viewModel: viewModel)
            case "Dietary":
                DietaryEditView(viewModel: viewModel)
            case "Allergies":
                AllergiesEditView(viewModel: viewModel)
            case "Health concerns":
                HealthConcernsEditView(viewModel: viewModel)
            default:
                FSTextView("Edit \(title)", typography: .p_ui_medium)
            }
        } label: {
            HStack {
                FSTextView(title, typography: .p_ui_medium)
                Spacer()
                FSTextView(value ?? "", typography: .p_ui, color: .fsMutedForeground)
                Image(systemName: "chevron.right")
                    .foregroundColor(.fsMutedForeground)
                    .font(.system(size: 14))
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func linkRow(_ title: String) -> some View {
        NavigationLink {
            switch title {
            case "Change password":
                ChangePasswordView()
            default:
                FSTextView(title, typography: .p_ui_medium)
            }
        } label: {
            HStack {
                FSTextView(title, typography: .p_ui_medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.fsMutedForeground)
                    .font(.system(size: 14))
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func settingsLinkLabel(_ title: String) -> some View {
        HStack {
            FSTextView(title, typography: .p_ui_medium)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.fsMutedForeground)
                .font(.system(size: 14))
        }
        .padding()
        .contentShape(Rectangle())
    }
    
    private func formatWorkoutDays(_ weekDays: [OptionItem]?) -> String {
        let workoutDays = weekDays?.compactMap { WeekDayType(rawValue: $0.id) } ?? []
        return workoutDays.sorted(by: { $0.intValue < $1.intValue })
            .map { $0.shortName }
            .joined(separator: " ")
    }
    
    private var buildVersionText: some View {
        HStack(spacing: 4) {
            Text("Version")
                .foregroundColor(.secondary)
            Text(Bundle.main.releaseVersionNumber ?? "")
                .foregroundColor(.secondary)
            Text("(\(Bundle.main.buildVersionNumber ?? ""))")
                .foregroundColor(.secondary)
        }
        .font(.caption2)
    }
    
    private func clearAllData() {
        // Clear UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        try? modelContext.delete(model: UserProfileEntity.self)
        // Clear auth tokens
        NetworkSession.shared.clearTokens()
        
        // Clear URL cache
        URLCache.shared.removeAllCachedResponses()
        
        // Clear file cache if any
        clearCache()
        
        appViewModel.authState = .unauthenticated
        superwall.endTrial()
        triggerHaptics()
    }
    
    private func clearCache() {
        // Clear NSCache
        let cache = NSCache<NSString, AnyObject>()
        cache.removeAllObjects()
        
        // Clear temporary files
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        do {
            let temporaryFiles = try FileManager.default.contentsOfDirectory(
                at: temporaryDirectoryURL,
                includingPropertiesForKeys: nil
            )
            try temporaryFiles.forEach { url in
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("Error clearing cache: \(error)")
        }
        triggerHaptics()
    }
    
    private var debugMenuSection: some View {
        HStack(spacing: 24) {
            Spacer()
            buildVersionText
            if showDebugMenu {
                HStack(spacing: 12) {
                    Text("|")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(superwall.status)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("|")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
               
                Menu {
                    Button(role: .destructive, action: clearAllData) {
                        Label("Clear All Data", systemImage: "trash")
                    }
                    
                    Button(action: clearCache) {
                        Label("Clear Cache", systemImage: "arrow.triangle.2.circlepath")
                    }
                } label: {
                    Text("Debug Menu")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }
}
