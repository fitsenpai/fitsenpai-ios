//
//  SettingsMainView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/9/25.
//

import SwiftUI
import Combine
import StoreKit

struct SettingsMainView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showRateApp = false
    @State private var showSafariView = false
    @State private var safariURL: URL?
    @State private var isPresentedManageSubscription: Bool = false
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @EnvironmentObject var appState: AppViewModel
    
    // URLs
    private let supportEmail = "support@fitsenpai.com"
    private let termsURL = "https://www.fitsenpai.com/terms"
    private let privacyURL = "https://www.fitsenpai.com/privacy-policy"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                FSText(text: "Settings", fontStyle: .heading24)
                    .padding(.top, 32)
                
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
                
                if !appViewModel.isLimitedAccess {
                    deleteAccountButton
                        .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 24)
            .manageSubscriptionsSheet(isPresented: $isPresentedManageSubscription)
        }
        
        .environmentObject(viewModel)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
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
        .loadingOverlay(state: $viewModel.viewState)
        .sheet(isPresented: $showSafariView) {
            if let url = safariURL {
                SafariView(url: url)
            }
        }
    }
    
    private var profileHeader: some View {
        FSCard(borderColor: .gray230) {
            HStack(alignment: .center, spacing: 16) {
                Image(appViewModel.isLimitedAccess ? .avatarPlaceholder : .imgDummyProf1)
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
                    if appViewModel.isLimitedAccess {
                        FSPill(text: "GUEST", color: .gray)
                    } else {
                        FSPill(text: "PRO", color: .fsPrimary)
                    }
                    
                    Text(verbatim: appViewModel.isLimitedAccess ? "Anonymous user" : "bella@fitsenpai.com")
                        .font(.body16)
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.bodyBold14)
            .foregroundColor(.black.opacity(0.6))
            .padding(.vertical, 8)
    }
    
    private var profileSection: some View {
        VStack(spacing: 0) {
            settingsRow("Age", value: "\(viewModel.age)")
            Divider()
            settingsRow("Gender", value: viewModel.selectedGender.rawValue)
            Divider()
            settingsRow("Height & Weight", value: viewModel.formattedHeightWeight)
            Divider()
            settingsRow("Fitness goal", value: viewModel.selectedFitnessGoal.rawValue)
            Divider()
            settingsRow("Activity level", value: viewModel.selectedActivityLevel.rawValue)
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var preferencesSection: some View {
        VStack(spacing: 0) {
            settingsRow("Workout location", value: viewModel.selectedWorkoutLocation.rawValue)
            Divider()
            settingsRow("Workout days", value: formatWorkoutDays(viewModel.workoutDays))
            Divider()
            settingsRow("Workout duration", value: viewModel.selectedWorkoutDuration.rawValue)
            Divider()
            settingsRow("Difficulty level", value: viewModel.selectedExerciseDifficulty.rawValue)
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
                URLHelper.openMail(to: supportEmail)
            } label: {
                settingsLinkLabel("Contact support")
            }
            Divider()
            
            // Terms & Conditions
            Button {
                safariURL = URL(string: termsURL)
                showSafariView = true
            } label: {
                settingsLinkLabel("Terms & conditions")
            }
            Divider()
            
            // Privacy Policy
            Button {
                safariURL = URL(string: privacyURL)
                showSafariView = true
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
            Text("Give feedback")
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            withoutAnimation {
                viewModel.activePopup = .rating
            }
        }
        .sheet(item: $viewModel.activeSheet, content: { type in
            switch type {
            case .negative:
                NegativeFeedbackSheet(feedbackType: $viewModel.activeSheet)
                    .flexibleSheet()
                    .background(.thickMaterial)
            case .positive, .negativeInput:
                NegativeFeedbackInoutSheet()
                    .flexibleSheet()
                    .background(.thickMaterial)
            }
        })
        .fullScreenCover(item: $viewModel.activePopup, content: { popup in
            ZStack {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showRateApp = false
                    }
                switch popup {
                case .rating:
                    RateAppPopupView {
                        viewModel.activeSheet = .negative
                    }
                case .logout:
                    LogoutPopupView {
                        Task {
                            let success = await viewModel.signOut()
                            if success {
                                appState.isLoggedIn = false
                            }
                        }
                    }
                }
            }
            .background(BackgroundClearView())
        })
    }
    
    private var accountSection: some View {
        VStack(spacing: 0) {
            linkRow("Restore purchase")
            if !appViewModel.isLimitedAccess {
                Divider()
                Button {
                    Task {
                        await MainActor.run {
                            isPresentedManageSubscription = true
                        }
                    }
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
                } label: {
                    HStack {
                        Text("Log out")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding()
                    .contentShape(Rectangle())
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
                    Text("Delete account")
                        .foregroundColor(.red)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
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
    
    private func settingsRow(_ title: String, value: String) -> some View {
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
                Text("Edit \(title)")
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Text(value)
                    .foregroundColor(.gray)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
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
            case "Rate the app":
                Text("Rate the app") // This should be handled by the rate app popup
            default:
                Text(title)
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func settingsLinkLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .contentShape(Rectangle())
    }
    
    private func formatWorkoutDays(_ days: Set<Int>) -> String {
        let weekDays = days.compactMap { WeekDay(rawValue: $0) }
        return weekDays.sorted(by: { $0.rawValue < $1.rawValue })
            .map { $0.shortName }
            .joined(separator: " ")
    }
}

#Preview {
    SettingsMainView()
}
