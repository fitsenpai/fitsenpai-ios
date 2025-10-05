//
//  AppStorage.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/2/25.
//


@MainActor
public struct AppStorage {
    @AppState(\.userID) static var userID
    @AppState(\.userEmail) static var userEmail
    @AppState(\.accessToken) static var accessToken
    @AppState(\.refreshToken) static var refreshToken
    @AppState(\.trialStartDate) static var trialStartDate
    @AppState(\.loginMethod) static var loginMethod
    
    public static func removeSession() {
        self.userID = nil
        self.userEmail = nil
        self.accessToken = nil
        self.userEmail = nil
        self.refreshToken = nil
        self.trialStartDate = nil
        self.loginMethod = nil
    }
}
