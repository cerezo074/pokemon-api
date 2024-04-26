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
    
    func loadPokemons() async throws -> (pokemon: [Chinpokomon], hasMorePokemon: Bool) {
        let lastPaginationObject = try await localRepository.getCurrentPaginationObject()
        let result = try await remoteRepository.load(with: lastPaginationObject)
        try await localRepository.saveCurrentPokemons(
            with: result.pokemons,
            with: result.currentPaginationObject
        )
        
        return (result.pokemons, result.hasMorePokemons)
    }
    
    // In case there were cached pokemons we are gonna re-use them too.
    func loadInitialState() async throws -> (pokemon: [Chinpokomon], hasMorePokemon: Bool)? {
        guard let result = try await localRepository.loadIntialState() else {
            return nil
        }
        
        return (result.pokemons, result.hasMorePokemons)
    }
}
