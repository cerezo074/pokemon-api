//
//  PokemonRemoteRepositoryTests.swift
//  PokeapiTests
//
//  Created by eli on 29/04/24.
//

import Foundation
import XCTest
import PokemonAPI
@testable import Pokeapi

class PokemonRemoteRepositoryTests: XCTestCase {
    
    private var service: PokemonRemoteRepository!
    private var customURLSession: URLSession!
    
    override func setUp() async throws {
        customURLSession = URLSession.mockedResponsesOnly
        service = PokemonRemoteRepository(pokemonsPerRequest: 1, customURLSession: customURLSession)
    }
    
    override func tearDownWithError() throws {
        RequestMocking.removeAllMocks()
    }

    func test_load_whenIsFirstTime_thenReturnsSuccessResultObject() async throws {
        try addMocks(
            shouldPassPokemonListRequest: true,
            shouldPassBulbasaurPokemonRequest: true
        )
        
        let result = try await service.load(with: nil)
        
        let expectedPokemon = try XCTUnwrap(MockObject.bulbasaurPKMPokemon)
        XCTAssertTrue(result.hasMorePokemons)
        XCTAssertEqual(result.pokemons.first, Pokemon(data: expectedPokemon))
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
                rightURLString: result.PKMPagination.next ?? ""
            )
        )
        XCTAssertNil(result.PKMPagination.previous)
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?limit=1&offset=0",
                rightURLString: result.PKMPagination.current
            )
        )
        XCTAssertEqual(result.PKMPagination.count, 1302)
        XCTAssertEqual(result.PKMPagination.limit, 1)
        XCTAssertEqual(result.PKMPagination.offset, 0)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    func test_load_whenPokemonListFails_thenReturnsException() async throws {
        try addMocks(
            shouldPassPokemonListRequest: false,
            shouldPassBulbasaurPokemonRequest: true
        )
        
        do {
            _ = try await service.load(with: nil)
            
            XCTFail("Can't return a result object")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_load_whenPokemonDetailFails_thenReturnsZeroPokemon() async throws {
        try addMocks(
            shouldPassPokemonListRequest: true,
            shouldPassBulbasaurPokemonRequest: false
        )
        
        let result = try await service.load(with: nil)
        
        XCTAssertNotNil(result.PKMPagination.current)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(result.pokemons.count, 0)
    }
    
    func test_load_whenPokemonListIsEmpty_thenReturnsZeroPokemon() async throws {
        try addMocks(
            shouldPassPokemonListRequest: true,
            useEmptyPokemonList: true,
            shouldPassBulbasaurPokemonRequest: false
        )
        
        let result = try await service.load(with: nil)
        
        XCTAssertNotNil(result.PKMPagination.current)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(result.pokemons.count, 0)
    }
    
    func test_load_whenPokemonListIsNull_thenReturnsNilPokemonList() async throws {
        try addMocks(
            shouldPassPokemonListRequest: true,
            useNullPokemonList: true,
            shouldPassBulbasaurPokemonRequest: false
        )
        
        let result = try await service.load(with: nil)
        
        XCTAssertNotNil(result.PKMPagination.current)
        XCTAssertNil(result.PKMPagination.results)
        XCTAssertEqual(result.pokemons.count, 0)
    }
    
    func test_load_whenPokemonDetailIsEmpty_thenReturnsZeroPokemon() async throws {
        try addMocks(
            shouldPassPokemonListRequest: true,
            shouldPassBulbasaurPokemonRequest: true,
            useEmptyPokemonDetail: true
        )
        
        let result = try await service.load(with: nil)
        
        XCTAssertNotNil(result.PKMPagination.current)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(result.pokemons.count, 0)
    }
    
    func test_load_whenLoadNextPage_thenReturnsPokemon() async throws {
        let previousPage = try XCTUnwrap(MockObject.nextPagePokemonList)
        try addMocks(
            shouldPassPokemonListRequest: true,
            useNextPagePokemonList: true,
            shouldPassBulbasaurPokemonRequest: true
        )
        let result = try await service.load(with: previousPage)
        
        let expectedPokemon = try XCTUnwrap(MockObject.bulbasaurPKMPokemon)
        XCTAssertFalse(result.hasMorePokemons)
        XCTAssertEqual(result.pokemons.first, Pokemon(data: expectedPokemon))
        XCTAssertNil(result.PKMPagination.next)
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?limit=1&offset=0",
                rightURLString: result.PKMPagination.previous ?? ""
            )
        )
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?limit=1&offset=1",
                rightURLString: result.PKMPagination.current
            )
        )
        XCTAssertEqual(result.PKMPagination.count, 2)
        XCTAssertEqual(result.PKMPagination.limit, 1)
        XCTAssertEqual(result.PKMPagination.offset, 1)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    func test_load_whenLoadLastPage_thenReturnsPokemon() async throws {
        let lastPage = try XCTUnwrap(MockObject.lastPagePokemonList)
        try addMocks(
            shouldPassPokemonListRequest: true,
            useLastPagePokemonList: true,
            shouldPassBulbasaurPokemonRequest: true
        )
        
        let result = try await service.load(with: lastPage)
        
        let expectedPokemon = try XCTUnwrap(MockObject.bulbasaurPKMPokemon)
        XCTAssertFalse(result.hasMorePokemons)
        XCTAssertEqual(result.pokemons.first, Pokemon(data: expectedPokemon))
        XCTAssertNil(result.PKMPagination.next)
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?limit=1&offset=0",
                rightURLString: result.PKMPagination.previous ?? ""
            )
        )
        XCTAssertTrue(
            URL.compareURLs(
                leftURLString: "https://pokeapi.co/api/v2/pokemon?limit=1&offset=2",
                rightURLString: result.PKMPagination.current
            )
        )
        XCTAssertEqual(result.PKMPagination.count, 2)
        XCTAssertEqual(result.PKMPagination.limit, 1)
        XCTAssertEqual(result.PKMPagination.offset, 2)
        XCTAssertEqual(result.PKMPagination.results?.count, 1)
        XCTAssertEqual(result.PKMPagination.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    private func addMocks(
        shouldPassPokemonListRequest: Bool,
        useEmptyPokemonList: Bool = false,
        useNullPokemonList: Bool = false,
        useNextPagePokemonList: Bool = false,
        useLastPagePokemonList: Bool = false,
        shouldPassBulbasaurPokemonRequest: Bool,
        useEmptyPokemonDetail: Bool = false
    ) throws {
        RequestMocking.add(
            mock: try mockPokemonList(
                shouldPassPokemonListRequest,
                useEmptyPokemonList,
                useNullPokemonList,
                useNextPagePokemonList,
                useLastPagePokemonList
            )
        )
        RequestMocking.add(
            mock: try mockPokemonDetail(
                shouldPassBulbasaurPokemonRequest,
                useEmptyPokemonDetail
            )
        )
    }
    
    private func mockPokemonList(
        _ shouldPassPokemonListRequest: Bool,
        _ useEmptyListResult: Bool,
        _ useNullListResult: Bool,
        _ useNextPageResult: Bool,
        _ useLastPageResult: Bool
    ) throws -> RequestMocking.MockedResponse {
        let pokemonListData: Data
        var pokemonListURL = "https://pokeapi.co/api/v2/pokemon?limit=1&offset=0"
        
        if useEmptyListResult {
            pokemonListData = try XCTUnwrap(MockObject.emptyInitalPaginationPokemonListData)
        } else if useNullListResult {
            pokemonListData = try XCTUnwrap(MockObject.nullInitalPaginationPokemonListData)
        } else if useNextPageResult {
            pokemonListData = try XCTUnwrap(MockObject.nextPagePokemonListData)
            pokemonListURL = "https://pokeapi.co/api/v2/pokemon?limit=1&offset=1"
        } else if useLastPageResult {
            pokemonListData = try XCTUnwrap(MockObject.lastPagePokemonListData)
            pokemonListURL = "https://pokeapi.co/api/v2/pokemon?limit=1&offset=2"
        } else {
            pokemonListData = try XCTUnwrap(MockObject.initalPaginationPokemonListData)
        }
        
        return RequestMocking.createMockResponse(
            requestURL: pokemonListURL,
            successData: pokemonListData,
            isSuccessful: shouldPassPokemonListRequest
        )
    }
    
    private func mockPokemonDetail(
        _ shouldPassBulbasaurPokemonRequest: Bool,
        _ useEmptyPokemonResult: Bool
    ) throws -> RequestMocking.MockedResponse {
        let bulbasaurData: Data
        
        if useEmptyPokemonResult {
            bulbasaurData = try XCTUnwrap(MockObject.emptyBulbasaurData)
        } else {
            bulbasaurData = try XCTUnwrap(MockObject.bulbasaurData)
        }
        
        return RequestMocking.createMockResponse(
            requestURL: "https://pokeapi.co/api/v2/pokemon/bulbasaur",
            successData: bulbasaurData,
            isSuccessful: shouldPassBulbasaurPokemonRequest
        )
    }
}

