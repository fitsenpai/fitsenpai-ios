//
//  AppState.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI
import Combine

@propertyWrapper
struct AppState<Value>: DynamicProperty {
    
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences
    
    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") }
    }
    
    init(wrappedValue: Value, _ key: String) {
        self.defaultValue = wrappedValue
        self.key = key
    }
    
    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
        
            
            if defaultValue is Date? {
                if let timestamp = container.object(forKey: key) as? TimeInterval {
                    return Date(timeIntervalSince1970: timestamp) as! Value
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
            
            container.synchronize()
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

final class PublisherObservableObject: ObservableObject {
    
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
