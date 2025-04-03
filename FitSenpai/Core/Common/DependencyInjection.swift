import Foundation

@propertyWrapper
struct Inject<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.resolve()
    }
}

class DependencyInjector {
    private static var dependencies: [String: Any] = [:]
    
    static func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }
    
    static func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("No dependency found for \(key)")
        }
        return dependency
    }
}