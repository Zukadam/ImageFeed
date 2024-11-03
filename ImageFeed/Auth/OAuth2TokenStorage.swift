import Foundation

final class OAuth2TokenStorage {
    // MARK: - Public Properties
    var token: String? {
        get { storage.string(forKey: Keys.token.rawValue) }
        set { storage.set(newValue, forKey: Keys.token.rawValue) }
    }
    
    // MARK: - Private Properties
    private enum Keys: String {
        case token
    }
    
    private let storage: UserDefaults
    
    // MARK: - Initialisers
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    

}
