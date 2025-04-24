import Foundation

enum DIKey {
    case auth
    case user
    case workout
    case meal
    case profile
}

@propertyWrapper
struct Inject<T> {
    private let key: DIKey?
    
    init(key: DIKey? = nil) {
        self.key = key
    }
    
    var wrappedValue: T {
        DependencyInjector.resolve(key: key)
    }
}

class DependencyInjector {
    private static var dependencies: [String: Any] = [:]
    
    static func register<T>(_ dependency: T, key: DIKey? = nil) {
        let lookupKey: String
        if let key = key {
            lookupKey = String(describing: key)
        } else {
            lookupKey = String(describing: T.self)
        }
        dependencies[lookupKey] = dependency
    }
    
    static func resolve<T>(key: DIKey? = nil) -> T {
        let lookupKey: String
        if let key = key {
            lookupKey = String(describing: key)
        } else {
            lookupKey = String(describing: T.self)
        }
        
        guard let dependency = dependencies[lookupKey] as? T else {
            fatalError("No dependency found for \(lookupKey)")
        }
        return dependency
    }
}
