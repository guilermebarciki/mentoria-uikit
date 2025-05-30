import Foundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didLoadPokemonDetail(detail: PokemonDetail, isFavorited: Bool)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailViewModel {
    private let service = PokemonService()
    private let url: URL?
    
    weak var delegate: PokemonDetailViewModelDelegate?
    private var currentDetail: PokemonDetail?
    
    init(url: URL?) {
        self.url = url
    }
    
    func fetchPokemonDetail() {
        guard let url = url else { return }
        
        service.fetchPokemonDetail(from: url) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.currentDetail = detail
                self?.delegate?.didLoadPokemonDetail(
                    detail: detail,
                    isFavorited: self?.isFavorited() ?? false
                )
            case .failure(let error):
                self?.delegate?.didFailToLoadDetail(with: error)
            }
        }
    }
    
    func toggleFavorite() {
        guard let pokemon = currentDetail else { return }
        let name = pokemon.name.lowercased()
        
        if isFavorited() {
            FavoritePokemonLocalRepository.shared.remove(name)
        } else {
            FavoritePokemonLocalRepository.shared.add(name)
        }
    }
    
    private func isFavorited() -> Bool {
        guard let pokemon = currentDetail else { return false }
        return FavoritePokemonLocalRepository.shared.contains(pokemon.name.lowercased())
    }
}

final class FavoritePokemonLocalRepository {
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
