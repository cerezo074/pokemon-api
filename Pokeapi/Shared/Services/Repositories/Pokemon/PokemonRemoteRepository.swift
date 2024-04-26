//
//  PokemonRemoteRepository.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

protocol PokemonRemoteDataServices {
    func load(
        with currentPaginationObject: PKMPagedObject<PKMPokemon>?
    ) async throws -> PokemonRepositoryResult
}

struct PokemonRepositoryResult {
    let pokemons: [Chinpokomon]
    let hasMorePokemons: Bool
    var currentPaginationObject: PKMPagedObject<PKMPokemon>
}

class PokemonRemoteRepository: PokemonRemoteDataServices {
        
    private enum PokemonListError: Error {
        case invalidName
        case unknowError(pokemonName: String?, reason: String)
    }
    
    private let pokemonsPerRequest: Int
    private var currentPaginationObject: PKMPagedObject<PKMPokemon>?
    
    init(pokemonsPerRequest: Int = 20) {
        self.pokemonsPerRequest = pokemonsPerRequest
    }
    
    func load(
        with currentPaginationObject: PKMPagedObject<PKMPokemon>?
    ) async throws -> PokemonRepositoryResult {
        let currentPaginationState = getCurrentPaginationState(from: currentPaginationObject)
        
        let result = try await PokemonAPI().pokemonService.fetchPokemonList(
            paginationState: currentPaginationState
        )
        
        guard let pokemonResults = result.results as? [PKMNamedAPIResource<PKMPokemon>] else {
            return PokemonRepositoryResult(
                pokemons: [],
                hasMorePokemons: result.hasNext,
                currentPaginationObject: result
            )
        }
        
        let pokemons = try await PokemonRemoteRepository.getPokemons(with: pokemonResults)
        
        return PokemonRepositoryResult(
            pokemons: pokemons,
            hasMorePokemons: result.hasNext,
            currentPaginationObject: result
        )
    }
    
    private static func getPokemons(
        with pokemonResults: [PKMNamedAPIResource<PKMPokemon>]
    ) async throws -> [Chinpokomon] {
        return try await withThrowingTaskGroup(of: Result<Chinpokomon, Error>.self) { [] taskGroup in
            
            for pokemonResult in pokemonResults {
                taskGroup.addTask(priority: .background) {
                    do {
                        if let name = pokemonResult.name {
                            let downloadedPokemon = try await Self.getPokemon(with: name)
                            return Result.success(downloadedPokemon)
                        } else {
                            return Result.failure(PokemonListError.invalidName)
                        }
                    } catch {
                        return Result.failure(
                            PokemonListError.unknowError(
                                pokemonName: pokemonResult.name, reason: error.localizedDescription
                            )
                        )
                    }
                }
            }
            
            return try await taskGroup.reduce(into: [Chinpokomon]()) { partialResult, result in
                switch result {
                case let .success(pokemon):
                    partialResult.append(pokemon)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    private static func getPokemon(with name: String) async throws -> Chinpokomon {
        let downloadedPokemon = try await PokemonAPI().pokemonService.fetchPokemon(name)
            
        var pokemonLargeImage: URL? = nil
        
        if let pokemonID = downloadedPokemon.id {
            pokemonLargeImage = makeLargeImageURL(for: pokemonID)
        }
        
        return Chinpokomon(data: downloadedPokemon, largeImage: pokemonLargeImage)
    }
    
    private func getCurrentPaginationState(
        from paginationObject: PKMPagedObject<PKMPokemon>? = nil
    ) -> PaginationState<PKMPokemon> {
        guard let paginationObject else {
            return .initial(pageLimit: pokemonsPerRequest)
        }
        
        guard paginationObject.hasNext else {
            return .continuing(paginationObject, .last)
        }
        
        return .continuing(paginationObject, .next)
    }
    
    private static func makeLargeImageURL(for id: Int) -> URL? {
        return URL.init(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}

/**
 Class used from swiftui previews or unit tests
 */
class PokemonRemoteMockRepository: PokemonRemoteDataServices {
    
    func load(
        with currentPaginationObject: PKMPagedObject<PKMPokemon>?
    ) async throws -> PokemonRepositoryResult {
        return .init(
            pokemons: [],
            hasMorePokemons: false,
            currentPaginationObject: PKMPagedObject<PKMPokemon>.makePagination()
        )
    }

}