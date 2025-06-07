@testable import MentoriaUIKitbasico

import XCTest

final class PokemonListViewModelTests: XCTestCase {
    private var sut: PokemonListViewModel!
    private var mockService: MockPokemonService!
    private var mockDelegate: MockPokemonListDelegate!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDelegate = MockPokemonListDelegate()
        sut = PokemonListViewModel(service: mockService)
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPokemons_whenSuccess_shouldNotifyDelegateAndStoreData() {
            // Given
            let pokemon = Pokemon(
                name: "bulbasaur",
                number: 1,
                pokemonImage: "bulbasaur.png",
                pokemonUrl: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")
            )
            mockService.result = .success([pokemon])

            // When
            sut.fetchPokemons()

            // Then
            XCTAssertTrue(mockDelegate.didUpdateCalled)
            XCTAssertEqual(sut.numberOfPokemons, 1)
            XCTAssertEqual(sut.getPokemon(at: 0).name, "bulbasaur")
            XCTAssertEqual(sut.getPokemon(at: 0).number, 1)
            XCTAssertEqual(sut.getPokemon(at: 0).pokemonImage, "bulbasaur.png")
            XCTAssertEqual(sut.getPokemon(at: 0).pokemonUrl, URL(string: "https://pokeapi.co/api/v2/pokemon/1/"))
        }

        func test_fetchPokemons_whenFailure_shouldNotifyDelegateWithError() {
            // Given
            mockService.result = .failure(ServiceError.emptyData)

            // When
            sut.fetchPokemons()

            // Then
            XCTAssertTrue(mockDelegate.didFailCalled)
            XCTAssertEqual(mockDelegate.errorMessage, ServiceError.emptyData.localizedDescription)
        }

        func test_numberOfPokemons_shouldReturnCorrectCount() {
            mockService.result = .success([.mock(), .mock(), .mock(), .mock()])
            
            // When
            sut.fetchPokemons()
            
            // Then
            XCTAssertEqual(sut.numberOfPokemons, 4)
        }

        func test_pokemonAt_shouldReturnCorrectPokemon() {
            // Given
            let mewtwo = Pokemon(name: "mewtwo", number: 150, pokemonImage: "mewtwo.png", pokemonUrl: nil)
            mockService.result = .success([mewtwo])

            // When
            sut.fetchPokemons()
            let result = sut.getPokemon(at: 0)

            // Then
            XCTAssertEqual(result.name, "mewtwo")
            XCTAssertEqual(result.number, 150)
            XCTAssertEqual(result.pokemonImage, "mewtwo.png")
        }
}
