@testable import MentoriaUIKitbasico

final class MockFavoritePokemonRepository: FavoritePokemonRepositoryProtocol {
    
    var pokemonAddedCalled: Bool = false
    var pokemonAdded: String?
    func add(_ name: String) {
        pokemonAdded = name
        pokemonAddedCalled = true
    }
    
    var pokemonRemovedCalled: Bool = false
    var pokemonRemoved: String?
    func remove(_ name: String) {
        pokemonRemoved = name
        pokemonRemovedCalled = true
    }
    
    var containsToBeReturned: Bool = false
    var containsCalled: Bool = false
    func contains(_ name: String) -> Bool {
        containsCalled = true
        return containsToBeReturned
    }
    
    func allFavorites() -> [String] {
        []
    }
    
    func reset() {
        
    }
}
