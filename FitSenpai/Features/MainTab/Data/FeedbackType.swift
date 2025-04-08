//
//  FeedbackType.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

enum FeedbackType: Identifiable {
    case positive
    case negative
    case negativeInput
    
    var id: Int {
        hashValue
    }
}
