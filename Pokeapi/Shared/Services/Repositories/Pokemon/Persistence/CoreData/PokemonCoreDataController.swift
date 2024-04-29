//
//  PokemonCoreDataController.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation
import CoreData

class PokemonCoreDataStack {
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "pokemon")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            } else {
                print("CoreData Stack loaded! :)")
            }
        }
        return container
    }()
    
}
