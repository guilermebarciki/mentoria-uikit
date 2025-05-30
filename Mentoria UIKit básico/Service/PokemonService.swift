import Foundation

final class PokemonService {
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        guard let url = URL(string: urlString) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(ServiceError.emptyData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                let pokemons = decoded.results.map { $0.toDomainModel() }
                completion(.success(pokemons))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

// MARK: - ServiceError

enum ServiceError: Error {
    case invalidURL
    case emptyData
}
