//
//  PokemonRepository.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine
import PokemonAPI

class PokemonRepository {
    
    private let pokemonRemoteRepository: PokemonRemoteDataServices
    
    init(remoteRepository: PokemonRemoteDataServices) {
        self.pokemonRemoteRepository = remoteRepository
    }
    
    func loadPokemons() async throws -> PokemonFetchDataResult {
        //TODO: Use local persistence to save the data from the last result before returning it
        return try await pokemonRemoteRepository.load()
    }
}

protocol PokemonRemoteDataServices {
    func load() async throws -> PokemonFetchDataResult
}

struct PokemonFetchDataResult {
    let pokemons: [Chinpokomon]
    let hasMorePokemons: Bool
}

class PokemonRemoteRepository: PokemonRemoteDataServices {
        
    private enum PokemonListError: Error {
        case invalidName
        case unknowError(pokemonName: String?, reason: String)
    }
    
    private let pokemonsPerRequest: Int
    private var currentPaginationObject: PKMPagedObject<PKMPokemon>?
    
    private var currentPaginationState: PaginationState<PKMPokemon>? {
        guard let currentPaginationObject else { return .initial(pageLimit: pokemonsPerRequest) }
        guard currentPaginationObject.hasNext else { return nil }
        
        return .continuing(currentPaginationObject, .next)
    }
    
    init(pokemonsPerRequest: Int = 20) {
        self.pokemonsPerRequest = pokemonsPerRequest
    }
    
    func load() async throws -> PokemonFetchDataResult {
        guard let currentPaginationState else {
            return PokemonFetchDataResult(pokemons: [], hasMorePokemons: false)
        }
        
        let result = try await PokemonAPI().pokemonService.fetchPokemonList(
            paginationState: currentPaginationState
        )
        
        guard let pokemonResults = result.results as? [PKMNamedAPIResource<PKMPokemon>] else {
            return PokemonFetchDataResult(pokemons: [], hasMorePokemons: result.hasNext)
        }
        
        let pokemons = try await PokemonRemoteRepository.getPokemons(with: pokemonResults)
        currentPaginationObject = result
        
        return PokemonFetchDataResult(pokemons: pokemons, hasMorePokemons: result.hasNext)
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
    
    private static func makeLargeImageURL(for id: Int) -> URL? {
        return URL.init(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
}

struct Chinpokomon: Comparable {
    //TODO: Get rid of this huge entity and use what is really necessary
    let data: PKMPokemon
    let largeImage: URL?
    
    var pokemonThumbnailImageURL: URL? {
        guard let frontDefaultImage = data.sprites?.frontDefault else {
            return nil
        }
        
        return URL.init(string: frontDefaultImage)
    }
    
    static func < (lhs: Chinpokomon, rhs: Chinpokomon) -> Bool {
        (lhs.data.id ?? -1) < (rhs.data.id ?? -1)
    }
    
    static func == (lhs: Chinpokomon, rhs: Chinpokomon) -> Bool {
        lhs.data.id == rhs.data.id
    }
}
