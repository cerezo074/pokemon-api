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
    private let filePersistence: FilePersistenceServices
    private let coreDataStack: PokemonCoreDataStack
    private static let pokemonPaginationFile = "pokemon_pagination.json"
    private static let pokemonListFile = "pokemon_list.json"

    init(
        pokemons: [Pokemon] = [],
        currentAPIPagination: PokemonAPIPagination? = nil,
        filePersistence: FilePersistenceServices? = nil,
        coreDataStack: PokemonCoreDataStack? = nil
    ) {
        self.coreDataStack = coreDataStack ?? .init(useInMemoryPersistence: false)
        self.filePersistence = filePersistence ?? DocumentsFolderPersistence()
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
        
        //TODO: Replace file persistence with Core Data, this will help us much with querying instead of loading all
        //data and apply some filters
        
        try await withCheckedThrowingContinuation { [weak filePersistence] (continuation: CheckedContinuation<Void, Error>) -> Void in
            guard let filePersistence else {
                continuation.resume()
                return
            }
            
            filePersistence.saveData(for: currentAPIPagination, to: Self.pokemonPaginationFile) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
        
        try await withCheckedThrowingContinuation { [weak filePersistence] (continuation: CheckedContinuation<Void, Error>) -> Void in
            guard let filePersistence else {
                continuation.resume()
                return
            }
            
            filePersistence.saveData(for: pokemons, to: Self.pokemonListFile) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        //TODO: Replace file persistence with Core Data, this will help us much with querying instead of loading all
        //data and apply some filters later.
        
        let currentAPIPagination: PokemonAPIPagination? = try await withCheckedThrowingContinuation {
            [weak filePersistence] (continuation: CheckedContinuation<PokemonAPIPagination?, Error>) -> Void in
            
            guard let filePersistence else {
                continuation.resume(returning: nil)
                return
            }
            
            filePersistence.loadData(from: Self.pokemonPaginationFile) { 
                (result: Result<PokemonAPIPagination?, Error>) in
                switch result {
                case .success(let object):
                    continuation.resume(returning: object)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        let pokemons: [Pokemon] = try await withCheckedThrowingContinuation {
            [weak filePersistence] (continuation: CheckedContinuation<[Pokemon], Error>) -> Void in
            
            guard let filePersistence else {
                continuation.resume(returning: [])
                return
            }
            
            filePersistence.loadData(from: Self.pokemonListFile) {
                (result: Result<[Pokemon], Error>) in
                switch result {
                case .success(let object):
                    continuation.resume(returning: object)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

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
    
    private func savePokemonsOnCoreData(with newPokemons: [Pokemon]) async throws {
        
    }
}
