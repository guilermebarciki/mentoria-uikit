@testable import MentoriaUIKitbasico

final class MockPokemonService: PokemonServiceProtocol {
    var result: Result<[Pokemon], Error>?
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

