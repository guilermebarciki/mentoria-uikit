import Foundation
import Security

final class FavoritePokemonKeychainRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonKeychainRepository()
    
    private let service = "com.yourapp.favoritePokemon"
    private let account = "favorites"
    
    private init() {}
    
    func add(_ name: String) {
        var favorites = getFavorites()
        favorites.insert(name.lowercased())
        saveFavorites(favorites)
    }
    
    func remove(_ name: String) {
        var favorites = getFavorites()
        favorites.remove(name.lowercased())
        saveFavorites(favorites)
    }
    
    func contains(_ name: String) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(name.lowercased())
    }
    
    func allFavorites() -> [String] {
        return Array(getFavorites())
    }
    
    // MARK: - Private Keychain Methods
    
    private func getFavorites() -> Set<String> {
        guard let data = readFromKeychain() else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([String].self, from: data)
            return Set(favorites)
        } catch {
            print("Error decoding favorites from Keychain: \(error)")
            return []
        }
    }
    
    private func saveFavorites(_ favorites: Set<String>) {
        do {
            let data = try JSONEncoder().encode(Array(favorites))
            saveToKeychain(data)
        } catch {
            print("Error encoding favorites for Keychain: \(error)")
        }
    }
    
    private func saveToKeychain(_ data: Data) {
        // First delete any existing item
        deleteFromKeychain()
        
        // Create query for saving data
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // Add the item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess && status != errSecDuplicateItem {
            print("Error saving to Keychain: \(status)")
        }
    }
    
    private func readFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            if status != errSecItemNotFound {
                print("Error reading from Keychain: \(status)")
            }
            return nil
        }
    }
    
    private func deleteFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting from Keychain: \(status)")
        }
    }
}
