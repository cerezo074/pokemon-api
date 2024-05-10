//
//  PokemonCoreDataController.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation
import CoreData

protocol PokemonCoreDataPersistenceServices: AnyObject {
    func save(_ pokemons: [Pokemon]) async throws
    func loadPokemons() async throws -> [Pokemon]
}

class PokemonCoreDataStack: PokemonCoreDataPersistenceServices {
    
    let useInMemoryPersistence: Bool
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "pokemon")
        
        if useInMemoryPersistence {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        print(
            "Core data store location: \(persistentContainer.persistentStoreDescriptions.first?.url?.absoluteString ?? "")"
        )
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("\nFailed to load persistent stores: \(error)")
            } else {
                print("\nCoreData Stack loaded! :)")
            }
        }
        
        return persistentContainer
    }()
    
    init(useInMemoryPersistence: Bool) {
        self.useInMemoryPersistence = useInMemoryPersistence
    }
    
    func save(_ pokemons: [Pokemon]) async throws {
        let backgroundContext = makeContextWithData(with: pokemons)
        backgroundContext.mergePolicy = NSMergePolicy(
            merge: .mergeByPropertyObjectTrumpMergePolicyType
        )

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            backgroundContext.perform {
                do {
                    try backgroundContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func loadPokemons() async throws -> [Pokemon] {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let fetchRequest = CDPokemon.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[Pokemon], Error>) in
            backgroundContext.perform {
                do {
                    let pokemons = try backgroundContext.fetch(fetchRequest).compactMap { Pokemon.init(data: $0) }
                    continuation.resume(returning: pokemons)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func makeContextWithData(with pokemons: [Pokemon]) -> NSManagedObjectContext {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        for pokemon in pokemons {
            let CDPokemon = CDPokemon(context: backgroundContext)
            CDPokemon.id = Int64(pokemon.id)
            CDPokemon.name = pokemon.name
            CDPokemon.largeImageURL = pokemon.largeImageURL
            CDPokemon.thumbnailImageURL = pokemon.thumbnailImageURL
            CDPokemon.isFavorite = false
            
            let abilities = pokemon.abilities.map {
                let ability = CDAbility(context: backgroundContext)
                ability.id = Int64($0.id)
                ability.name = $0.value
                ability.addToPokemons(CDPokemon)

                return ability
            }
            
            let moves = pokemon.moves.map {
                let move = CDMove(context: backgroundContext)
                move.id = Int64($0.id)
                move.name = $0.value
                move.addToPokemons(CDPokemon)

                return move
            }
            
            let types = pokemon.types.map {
                let type = CDType(context: backgroundContext)
                type.id = Int64($0.id)
                type.name = $0.value
                type.addToPokemons(CDPokemon)
                
                return type
            }
            
            CDPokemon.addToAbilities(NSSet(array: abilities))
            CDPokemon.addToMoves(NSSet(array: moves))
            CDPokemon.addToTypes(NSSet(array: types))
        }
        
        return backgroundContext
    }
}
