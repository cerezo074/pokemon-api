//
//  PokemonLocalPersistence.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

protocol PokemonLocalDataServices {
    func getPokemon(at index: Int) async throws -> Chinpokomon
    func getPokemons() async throws -> [Chinpokomon]
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>?
    func loadIntialState() async throws -> PokemonRepositoryResult?
    func saveCurrentPokemons(
        with newPokemons: [Chinpokomon],
        with currentPaginationObject: PKMPagedObject<PKMPokemon>
    ) async throws
}

enum PokemonLocalDataError: Error {
    case pokemonNotFound
}

actor PokemonLocalPersistence: PokemonLocalDataServices {
    
    private var pokemons: [Chinpokomon]
    private var currentPaginationObject: PKMPagedObject<PKMPokemon>?
    
    // TODO: Inject persistence mechanism and hold it as an interface (e.g core data, file system)
    init(
        pokemons: [Chinpokomon] = [],
        currentPaginationObject: PKMPagedObject<PKMPokemon>? = nil
    ) {
        self.pokemons = pokemons
        self.currentPaginationObject = currentPaginationObject
    }
    
    func getPokemons() async throws -> [Chinpokomon] {
        return pokemons
    }
    
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>? {
        return currentPaginationObject
    }
    
    func saveCurrentPokemons(
        with newPokemons: [Chinpokomon],
        with currentPaginationObject: PKMPagedObject<PKMPokemon>
    ) async throws {
        //TODO: Call persistence and save these objects, in case objects can't be persisted extract
        // the relevant data and pass them to a new class. Keep in mind PKMPagedObject and PKMPokemon
        // are encodable objects so serializing them should not be a problem. For now let's use
        // in-memory persistence.
        self.pokemons.append(contentsOf: newPokemons)
        self.currentPaginationObject = currentPaginationObject
    }
    
    // TODO: Call persistence mechanism to retrived previous data from disk(e.g core data, file system)
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        guard let currentPaginationObject else {
            return nil
        }
        
        return PokemonRepositoryResult(
            pokemons: pokemons,
            hasMorePokemons: currentPaginationObject.hasNext,
            currentPaginationObject: currentPaginationObject
        )
    }
    
    func getPokemon(at index: Int) async throws -> Chinpokomon {
        guard index >= 0, index < pokemons.count else {
            throw PokemonLocalDataError.pokemonNotFound
        }
        
        return pokemons[index]
    }
}

class PokemonLocalMockPersistence: PokemonLocalDataServices {
    
    func getPokemon(at index: Int) async throws -> Chinpokomon {
        throw PokemonLocalDataError.pokemonNotFound
    }
    
    func getPokemons() async throws -> [Chinpokomon] {
        []
    }
    
    func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>? {
        return nil
    }
    
    func saveCurrentPokemons(
        with newPokemons: [Chinpokomon],
        with currentPaginationObject: PKMPagedObject<PKMPokemon>
    ) async throws {
        
    }
    
    func loadIntialState() async throws -> PokemonRepositoryResult? {
        return nil
    }
}
