//
//  AppState.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/25/25.
//


import SwiftUI
import Combine

@propertyWrapper
struct AppState<Value>: DynamicProperty {
    
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<UserPreferences, Value>
    private let preferences: UserPreferences
    
    init(_ keyPath: ReferenceWritableKeyPath<UserPreferences, Value>, preferences: UserPreferences = .standard) {
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
