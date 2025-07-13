//
//  FeedbackViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//

import Foundation
import CoreKit

@MainActor
final class FeedbackViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .idle

    @Inject private var sendFeedbackUseCase: SendFeedbackUseCaseProtocol
    
    func sendNegativeFeedback(message: String, category: String) async -> Result<Void, Error> {
        viewState = .loading
        defer { viewState = .idle }
        let date = Date().toString(WithFormat: "yyyy-MM-dd HH:mm:ss")
        do {
            try await sendFeedbackUseCase.execute(.init(message: message, category: category, trackingDate: date, type: "negative", path: ""))
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
