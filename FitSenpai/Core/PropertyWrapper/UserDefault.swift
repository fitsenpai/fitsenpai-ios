//
//  UserDefault.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/25/25.
//

import SwiftUI
import Combine

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    @available(*, unavailable, message: "Access wrappedValue directly is not supported. Use AppPreferences instead.")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    init(wrappedValue: Value, _ key: String) {
        self.defaultValue = wrappedValue
        self.key = key
    }
    
    public static subscript(
        _enclosingInstance instance: AppPreferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<AppPreferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<AppPreferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
            
            // Check if Value type is Date or Optional<Date>
            if Value.self == Date.self || Value.self == Date?.self {
                if let timestamp = container.object(forKey: key) as? TimeInterval {
                    if let dateValue = Date(timeIntervalSince1970: timestamp) as? Value {
                        return dateValue
                    }
                    return defaultValue
                }
                return defaultValue
            }
            
            let value = container.object(forKey: key) as? Value ?? defaultValue
            return value
        }
        set {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            
            if let optional = newValue as? OptionalType, optional.isNil {
                container.removeObject(forKey: key)
            } else if let date = newValue as? Date {
                let timestamp = date.timeIntervalSince1970
                container.set(timestamp, forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

private protocol OptionalType {
    var isNil: Bool { get }
}

extension Optional: OptionalType {
    var isNil: Bool { self == nil }
}