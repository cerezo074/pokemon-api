//
//  PokemonRepository.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine
import PokemonAPI

protocol PokemonDataServices {
    func loadPokemons()
}

class PokemonRepository: PokemonDataServices {
    
    private let pokemonRemoteRepository: PokemonRemoteDataServices
    
    init(remoteRepository: PokemonRemoteDataServices) {
        self.pokemonRemoteRepository = remoteRepository
    }
    
    func loadPokemons() {
        pokemonRemoteRepository.load()
    }
    
}

protocol PokemonRemoteDataServices {
    func load()
}

class PokemonRemoteRepository: PokemonRemoteDataServices {
    
    var hasNextValue: AnyPublisher<Bool, Never> {
        return hasNextValueSubject.removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private let hasNextValueSubject = CurrentValueSubject<Bool, Never>(false)
    
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
    
    func load() {
        Task {
            do {
                guard let currentPaginationState else {
                    hasNextValueSubject.send(false)
                    return
                }
                
                let result = try await PokemonAPI().pokemonService.fetchPokemonList(
                    paginationState: currentPaginationState
                )
                
                if let pokemonResults = result.results as? [PKMNamedAPIResource<PKMPokemon>] {
                    let pokemons = try await PokemonRemoteRepository.getPokemons(with: pokemonResults)
                    currentPaginationObject = result
                    print(pokemons)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private static func getPokemons(with pokemonResults: [PKMNamedAPIResource<PKMPokemon>]) async throws -> [Pokemon] {
        return try await withThrowingTaskGroup(of: Result<Pokemon, Error>.self) { [] taskGroup in
            
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
    
    private static func getPokemon(with name: String) async throws -> Pokemon {
        let downloadedPokemon = try await PokemonAPI().pokemonService.fetchPokemon(name)
            
        var pokemonLargeImage: URL? = nil
        
        if let pokemonID = downloadedPokemon.id {
            pokemonLargeImage = makeLargeImageURL(for: pokemonID)
        }
        
        return Pokemon(data: downloadedPokemon, largeImage: pokemonLargeImage)
    }
    
    private static func makeLargeImageURL(for id: Int) -> URL? {
        return URL.init(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
}

struct Pokemon {
    let data: PKMPokemon
    let largeImage: URL?
    
    var pokemonThumbnailImageURL: URL? {
        guard let frontDefaultImage = data.sprites?.frontDefault else {
            return nil
        }
        
        return URL.init(string: frontDefaultImage)
    }
}
