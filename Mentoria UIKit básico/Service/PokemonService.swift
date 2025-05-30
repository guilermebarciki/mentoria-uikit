import Foundation

final class PokemonService {
    let networkClient = NetworkClient()

    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        networkClient.fetch(from: urlString, decodeTo: PokemonListResponse.self) { result in
            switch result {
            case .success(let response):
                let pokemons = response.results.map { $0.toDomainModel() }
                completion(.success(pokemons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - ServiceError

enum ServiceError: Error {
    case invalidURL
    case emptyData
}
