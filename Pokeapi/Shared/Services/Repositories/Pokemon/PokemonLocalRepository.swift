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
    
    // TODO: Inject persistence mechanism and hold it as an interface (e.g core data, file system)
    init(
        pokemons: [Pokemon] = [],
        currentAPIPagination: PokemonAPIPagination? = nil
    ) {
        self.pokemons = pokemons
        self.currentAPIPagination = currentAPIPagination
    }
    
    func getPokemons() async throws -> [Pokemon] {
        return pokemons
    }
    
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>? {
        return currentAPIPagination?.makePKMPagination()
    }
    
    func saveCurrentPokemons(
        with newPokemons: [Pokemon],
        with currentPKMPagination: PKMPagedObject<PKMPokemon>
    ) async throws {
        //TODO: Call persistence and save these objects, in case objects can't be persisted extract
        // the relevant data and pass them to a new class. Keep in mind PKMPagedObject and PKMPokemon
        // are encodable objects so serializing them should not be a problem. For now let's use
        // in-memory persistence.
        self.pokemons.append(contentsOf: newPokemons)
        self.currentAPIPagination = PokemonAPIPagination(from: currentPKMPagination)
//        let coredataStack = PokemonCoreDataController.shared
//        let aaa = await coredataStack.persistentContainer.newBackgroundContext()
//        print(aaa)
    }
    
    // TODO: Call persistence mechanism to retrived previous data from disk(e.g core data, file system)
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        guard let currentAPIPagination else {
            return nil
        }
        
        let PKMPagination = currentAPIPagination.makePKMPagination()
        
        return PokemonRepositoryResult(
            pokemons: pokemons,
            hasMorePokemons: PKMPagination.hasNext,
            PKMPagination: PKMPagination
        )
    }
    
    func getPokemon(at index: Int) async throws -> Pokemon {
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
