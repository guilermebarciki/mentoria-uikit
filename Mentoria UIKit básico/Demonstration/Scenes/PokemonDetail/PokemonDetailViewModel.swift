import Foundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didLoadPokemonDetail(_ detail: PokemonDetail)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailViewModel {
    private let service = PokemonService()
    private let url: URL?
    
    weak var delegate: PokemonDetailViewModelDelegate?
    
    init(url: URL?) {
        self.url = url
    }
    
    func fetchPokemonDetail() {
        guard let url = url else { return }
        
        service.fetchPokemonDetail(from: url) { [weak self] result in
                switch result {
                case .success(let detail):
                    self?.delegate?.didLoadPokemonDetail(detail)
                case .failure(let error):
                    self?.delegate?.didFailToLoadDetail(with: error)
                }
        }
    }
}
