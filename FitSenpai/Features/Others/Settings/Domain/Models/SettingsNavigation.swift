import Foundation

enum SettingsNavigation: Hashable {
    case settings
}

enum SettingsPopup: Identifiable, Hashable {
    case rating
    case logout
    
    var id: Int {
        hashValue
    }
}
