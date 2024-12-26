//
//  GlobalAppEnvironment.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Auth

class GlobalAppEnvironment: ObservableObject {
    @Published var user:FSUser?
    @Published var weekToGenerate: Int?
}
