import Foundation

protocol PokemonListViewModelDelegate: AnyObject {
    func didUpdatePokemonList()
    func didFailWithError(_ message: String)
}

class PokemonListViewModel {
    
    weak var delegate: PokemonListViewModelDelegate?
    
    private(set) var pokemons: [Pokemon] = []
    
    func fetchPokemons() {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                self?.delegate?.didFailWithError("Erro de rede: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFailWithError("Dados inválidos")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                self?.pokemons = decoded.results.map { $0.toDomainModel() }
                self?.delegate?.didUpdatePokemonList()
            } catch {
                self?.delegate?.didFailWithError("Erro ao decodificar: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func pokemon(at index: Int) -> Pokemon {
        return pokemons[index]
    }
    
    var numberOfPokemons: Int {
        return pokemons.count
    }
}
