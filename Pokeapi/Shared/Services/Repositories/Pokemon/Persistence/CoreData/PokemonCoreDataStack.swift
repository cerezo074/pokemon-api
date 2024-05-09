//
//  PokemonCoreDataController.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation
import CoreData

class PokemonCoreDataStack {
    
    let useInMemoryPersistence: Bool
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "pokemon")
        
        if useInMemoryPersistence {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            } else {
                print("CoreData Stack loaded! :)")
            }
        }
        
        return persistentContainer
    }()
    
    init(useInMemoryPersistence: Bool) {
        self.useInMemoryPersistence = useInMemoryPersistence
    }
}
