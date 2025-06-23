//
//  GenerateWorkoutRequest.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

struct GenerateWorkoutRequest: ParameterProtocol {
    let date: String
}

struct RegenerateWorkoutRequest: ParameterProtocol {
    let date: String
    let instruction: String
}
