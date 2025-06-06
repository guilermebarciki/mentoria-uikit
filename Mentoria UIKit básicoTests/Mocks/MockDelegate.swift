@testable import MentoriaUIKitbasico

final class MockDelegate: PokemonListViewModelDelegate {
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
