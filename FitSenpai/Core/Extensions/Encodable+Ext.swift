//
//  Encodable+Ext.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
