//
//  FeedbackRepositoryProfocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//


import Foundation

protocol FeedbackRepositoryProfocol {
    func sendFeedback(_ params: FeedbackRequest) async throws 
}
