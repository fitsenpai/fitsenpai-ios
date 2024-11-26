//
//  FSEnvironment.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/26/24.
//

import Foundation


class FSEnvironment {
    
    var name: String
    var apiPath: String
    var isProduction: Bool
    
    
    init(envDict: [String: Any]) {
        self.name = envDict["name"] as! String
        self.apiPath = envDict["apiPath"] as! String
        self.isProduction = envDict["isProduction"] as! Bool
    }
}
