//
//  GenerateRequest.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

struct GenerateRequest: ParameterProtocol {
    let date: String
}

struct RegenerateRequest: ParameterProtocol {
    let date: String
    let instruction: String
}

struct UpdateRoutineRequest: ParameterProtocol {
    let date: String
    let name: String
}
