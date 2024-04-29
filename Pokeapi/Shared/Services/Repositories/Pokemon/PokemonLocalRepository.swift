//
//  PokemonLocalRepository.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

protocol PokemonLocalDataServices {
    func getPokemon(at index: Int) async throws -> Pokemon
    func getPokemons() async throws -> [Pokemon]
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>?
    func loadIntialState() async throws -> PokemonRepositoryResult?
    func saveCurrentPokemons(
        with newPokemons: [Pokemon],
        with currentPaginationObject: PKMPagedObject<PKMPokemon>
    ) async throws
}

enum PokemonLocalRepositoryError: Error {
    case pokemonNotFound
}

actor PokemonLocalRepository: PokemonLocalDataServices {
    
    private var pokemons: [Pokemon]
    private var currentAPIPagination: PokemonAPIPagination?
    private lazy var filePersistence = FilePersistence()
    private static let pokemonPaginationFile = "pokemon_pagination.json"
    private static let pokemonListFile = "pokemon_list.json"

    // TODO: Inject persistence mechanism and hold it as an interface (e.g core data, file system)
    init(
        pokemons: [Pokemon] = [],
        currentAPIPagination: PokemonAPIPagination? = nil
    ) {
        self.pokemons = pokemons
        self.currentAPIPagination = currentAPIPagination
    }
    
    func getPokemons() throws -> [Pokemon] {
        return pokemons
    }
    
    func getCurrentPaginationObject() throws -> PKMPagedObject<PKMPokemon>? {
        return currentAPIPagination?.makePKMPagination()
    }
    
    func saveCurrentPokemons(
        with newPokemons: [Pokemon],
        with currentPKMPagination: PKMPagedObject<PKMPokemon>
    ) async throws {
        self.pokemons.append(contentsOf: newPokemons)
        self.currentAPIPagination = PokemonAPIPagination(from: currentPKMPagination)
        
        //TODO: Replace file persistence with Core Data, this will help us much with querying instead of loading all
        //data and apply some filters
        try filePersistence.saveData(for: currentAPIPagination, to: Self.pokemonPaginationFile)
        try filePersistence.saveData(for: pokemons, to: Self.pokemonListFile)
    }
    
    func loadIntialState() throws -> PokemonRepositoryResult? {
        //TODO: Replace file persistence with Core Data, this will help us much with querying instead of loading all
        //data and apply some filters later.
        let currentAPIPagination: PokemonAPIPagination? = try filePersistence.loadData(from: Self.pokemonPaginationFile)
        let pokemons: [Pokemon] = try filePersistence.loadData(from: Self.pokemonListFile) ?? []

        guard let currentAPIPagination, !pokemons.isEmpty else {
            return nil
        }
        
        self.currentAPIPagination = currentAPIPagination
        self.pokemons = pokemons
        
        let PKMPagination = currentAPIPagination.makePKMPagination()
        
        return PokemonRepositoryResult(
            pokemons: pokemons,
            hasMorePokemons: PKMPagination.hasNext,
            PKMPagination: PKMPagination
        )
    }
    
    func getPokemon(at index: Int) throws -> Pokemon {
        guard index >= 0, index < pokemons.count else {
            throw PokemonLocalRepositoryError.pokemonNotFound
        }
        
        return pokemons[index]
    }
}

class PokemonLocalMockPersistence: PokemonLocalDataServices {
    
    func getPokemon(at index: Int) async throws -> Pokemon {
        throw PokemonLocalRepositoryError.pokemonNotFound
    }
    
    func getPokemons() async throws -> [Pokemon] {
        []
    }
    
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>? {
        return nil
    }
    
    func saveCurrentPokemons(
        with newPokemons: [Pokemon],
        with currentPaginationObject: PKMPagedObject<PKMPokemon>
    ) async throws {
        
    }
    
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        return nil
    }
}
