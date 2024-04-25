//
//  PokemonCatalogItem.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation

struct PokemonCatalogItem: Hashable, Identifiable {
    typealias ID = String
    let name: String
    let id: String
    let types: [String]
    let pokemonImageURL: URL?
    let backgroundImageURL: URL?
    
    var firstType: String? {
        return types.first
    }
    
    var showMoreTypeText: String? {
        return if types.count > 2 {
            "More"
        } else {
            nil
        }
    }
    
    var secondType: String? {
        if let showMoreTypeText = showMoreTypeText {
            return showMoreTypeText
        } else if types.count == 2 {
            return types.last
        } else {
            return nil
        }
    }
}
