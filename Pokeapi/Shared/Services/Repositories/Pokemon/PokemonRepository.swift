//
//  PokemonRepository.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import PokemonAPI

class PokemonRepository {
    
    private let remoteRepository: PokemonRemoteDataServices
    private let localRepository: PokemonLocalDataServices
    
    init(
        remoteRepository: PokemonRemoteDataServices,
        localRepository: PokemonLocalDataServices
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func loadPokemons() async throws -> (pokemon: [Pokemon], hasMorePokemon: Bool) {
        let lastPaginationObject = try await localRepository.getCurrentPaginationObject()
        let result = try await remoteRepository.load(with: lastPaginationObject)
        
        Task {
            do {
                try await localRepository.saveCurrentPokemons(
                    with: result.pokemons,
                    with: result.PKMPagination
                )
            } catch {
                print("Can't save downloaded data")
            }
        }
        
        return (result.pokemons, result.hasMorePokemons)
    }
    
    // In case there were cached pokemons we are gonna re-use them too.
    func loadInitialState() async throws -> (pokemon: [Pokemon], hasMorePokemon: Bool)? {
        guard let result = try await localRepository.loadIntialState() else {
            return nil
        }
        
        return (result.pokemons, result.hasMorePokemons)
    }
    
    func getPokemon(at index: Int) async throws -> Pokemon {
        return try await localRepository.getPokemon(at: index)
    }
}
