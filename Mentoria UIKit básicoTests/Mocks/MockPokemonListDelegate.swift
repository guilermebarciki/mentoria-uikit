@testable import MentoriaUIKitbasico

final class MockPokemonListDelegate: PokemonListViewModelDelegate {
       var didUpdateCalled = false
       var didFailCalled = false
       var errorMessage: String?

       func didUpdatePokemonList() {
           didUpdateCalled = true
       }

       func didFailWithError(_ message: String) {
           didFailCalled = true
           errorMessage = message
       }
   }


final class MockPokemonDetailDelegate: PokemonDetailViewModelDelegate {
    var didLoadDetailCalled = false
    var didFailCalled = false
    var loadedDetail: PokemonDetail?
    var loadedIsFavorited: Bool = false
    var failedWithError: Error?
    
    func didLoadPokemonDetail(detail: PokemonDetail, isFavorited: Bool) {
        didLoadDetailCalled = true
        loadedDetail = detail
        loadedIsFavorited = isFavorited
    }
    
    func didFailToLoadDetail(with error: Error) {
        didFailCalled = true
        failedWithError = error
    }
}
