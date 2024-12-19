//
//  UUIDTransform.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import Foundation
import ObjectMapper

class UUIDTransform: TransformType {
    typealias Object = UUID
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> UUID? {
        if let uuidString = value as? String {
            return UUID(uuidString: uuidString)
        }
        return nil
    }
    
    func transformToJSON(_ value: UUID?) -> String? {
        return value?.uuidString
    }
}
