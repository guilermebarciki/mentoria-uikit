import Foundation

protocol FavoritePokemonRepositoryProtocol {
    func add(_ name: String)
    func remove(_ name: String)
    func contains(_ name: String) -> Bool
    func allFavorites() -> [String]
}

final class FavoritePokemonLocalRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonLocalRepository()
    
    private var favorites: Set<String> = []
    
    private init() {}
    
    func add(_ name: String) {
        favorites.insert(name.lowercased())
    }
    
    func remove(_ name: String) {
        favorites.remove(name.lowercased())
    }
    
    func contains(_ name: String) -> Bool {
        favorites.contains(name.lowercased())
    }
    
    func allFavorites() -> [String] {
        Array(favorites)
    }
}

