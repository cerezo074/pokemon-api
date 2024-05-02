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
    let pokemons: [Pokemon]
    let hasMorePokemons: Bool
    var PKMPagination: PKMPagedObject<PKMPokemon>
}

class PokemonRemoteRepository: PokemonRemoteDataServices {
        
    enum PokemonListError: Error {
        case invalidData
        case unknowError(pokemonName: String?, reason: String)
    }
    
    private let urlSession: URLSession
    private let pokemonsPerRequest: Int
    private var currentPaginationObject: PKMPagedObject<PKMPokemon>?
    
    init(pokemonsPerRequest: Int = 20, customURLSession: URLSession? = nil) {
        self.pokemonsPerRequest = pokemonsPerRequest
        self.urlSession = customURLSession ?? URLSession.shared
    }
    
    func load(
        with currentPaginationObject: PKMPagedObject<PKMPokemon>?
    ) async throws -> PokemonRepositoryResult {
        let currentPaginationState = getCurrentPaginationState(from: currentPaginationObject)
        
        let result = try await PokemonAPI(session: urlSession)
            .pokemonService.fetchPokemonList(
                paginationState: currentPaginationState
            )
        
        guard let pokemonResults = result.results as? [PKMNamedAPIResource<PKMPokemon>] else {
            return PokemonRepositoryResult(
                pokemons: [],
                hasMorePokemons: result.hasNext,
                PKMPagination: result
            )
        }
        
        let pokemons = try await PokemonRemoteRepository.getPokemons(
            with: pokemonResults,
            with: urlSession
        )
        
        return PokemonRepositoryResult(
            pokemons: pokemons,
            hasMorePokemons: result.hasNext,
            PKMPagination: result
        )
    }
    
    private static func getPokemons(
        with pokemonResults: [PKMNamedAPIResource<PKMPokemon>],
        with urlSession: URLSession
    ) async throws -> [Pokemon] {
        return try await withThrowingTaskGroup(of: Result<Pokemon, Error>.self) { [] taskGroup in
            
            for pokemonResult in pokemonResults {
                taskGroup.addTask(priority: .background) {
                    do {
                        if let name = pokemonResult.name,
                           let downloadedPokemon = try await Self.getPokemon(
                            with: name,
                            with: urlSession
                           ) {
                            return Result.success(downloadedPokemon)
                        } else {
                            return Result.failure(PokemonListError.invalidData)
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
            
            return try await taskGroup.reduce(into: [Pokemon]()) { partialResult, result in
                switch result {
                case let .success(pokemon):
                    partialResult.append(pokemon)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    private static func getPokemon(with name: String, with urlSession: URLSession) async throws -> Pokemon? {
        let downloadedPokemon = try await PokemonAPI(session: urlSession)
            .pokemonService.fetchPokemon(name)
                
        return Pokemon(data: downloadedPokemon)
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
}
