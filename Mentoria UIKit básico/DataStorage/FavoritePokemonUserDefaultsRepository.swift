import Foundation

final class FavoritePokemonUserDefaultsRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonUserDefaultsRepository()
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "FavoritePokemon"
    
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
    
    // MARK: - Private Methods
    
    private func getFavorites() -> Set<String> {
        guard let favoritesArray = defaults.array(forKey: favoritesKey) as? [String] else {
            return []
        }
        return Set(favoritesArray)
    }
    
    private func saveFavorites(_ favorites: Set<String>) {
        defaults.set(Array(favorites), forKey: favoritesKey)
    }
}
