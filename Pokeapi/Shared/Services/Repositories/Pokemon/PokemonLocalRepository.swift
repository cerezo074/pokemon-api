//
//  PokemonLocalRepository.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI
import CoreData

protocol PokemonLocalDataServices {
    func getPokemon(for id: Int) async throws -> Pokemon
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
    private let filePersistenceProvider: FilePersistenceServices
    private let coreDataPersistenceProvider: PokemonCoreDataPersistenceServices
    private static let pokemonPaginationFile = "pokemon_pagination.json"

    init(
        pokemons: [Pokemon] = [],
        currentAPIPagination: PokemonAPIPagination? = nil,
        filePersistenceProvider: FilePersistenceServices? = nil,
        coreDataPersistenceProvider: PokemonCoreDataPersistenceServices? = nil
    ) {
        self.coreDataPersistenceProvider = coreDataPersistenceProvider ??
        PokemonCoreDataStack(useInMemoryPersistence: false)
        self.filePersistenceProvider = filePersistenceProvider ?? 
        DocumentsFolderPersistence()
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
        let currentAPIPagination = PokemonAPIPagination(from: currentPKMPagination)
        self.currentAPIPagination = currentAPIPagination
        
        // If Pokemons are saved without errors into core data we proceed
        // to save the paginated object but pagination depends on pokemons
        // persistence. WE NEED THESE OPERATIONS BEING EXECUTED SEQUENTIALLY
        
        try await coreDataPersistenceProvider.save(newPokemons)
        
        try await filePersistenceProvider.saveData(
            for: currentAPIPagination, to: Self.pokemonPaginationFile
        )
    }
    
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        let currentAPIPagination: PokemonAPIPagination? = try await filePersistenceProvider.loadData(
            from: Self.pokemonPaginationFile
        )
        
        let pokemons: [Pokemon] = try await coreDataPersistenceProvider.loadPokemons()

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
    
    func getPokemon(for id: Int) async throws -> Pokemon {
        guard let foundPokemon = pokemons.first(where: { $0.id == id }) else {
            throw PokemonLocalRepositoryError.pokemonNotFound
        }
        
        return foundPokemon
    }
}
