protocol PokemonListViewModelDelegate: AnyObject {
    func didUpdatePokemonList()
    func didFailWithError(_ message: String)
}

class PokemonListViewModel {
    
    weak var delegate: PokemonListViewModelDelegate?
    private let service = PokemonService()
    private(set) var pokemons: [Pokemon] = []

    func fetchPokemons() {
        service.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
                self?.delegate?.didUpdatePokemonList()
            case .failure(let error):
                self?.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func pokemon(at index: Int) -> Pokemon {
        return pokemons[index]
    }

    var numberOfPokemons: Int {
        return pokemons.count
    }
}
