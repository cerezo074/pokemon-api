//
//  PokemonCatalogItem.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import PokemonAPI

enum PokemonCatalogItemStyle: Hashable {
    case normal
    case load
    case retry
    
    var isRemovable: Bool {
        return self != .normal
    }
}

struct PokemonCatalogItemViewModel: Hashable, Identifiable {
    
    typealias ID = String
    let name: String
    let id: String
    let types: [String]
    let pokemonImageURL: URL?
    let backgroundImageURL: URL?
    let itemStyle: PokemonCatalogItemStyle
    
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
    
    init?(chinpokomon: Chinpokomon) {
        let pokemon = chinpokomon.data
        
        guard let pokemonName = pokemon.name,
              let pokemonID = pokemon.id else {
            return nil
        }
        
        name = pokemonName
        id = "#\(pokemonID)"
        types = pokemon.types?.compactMap({ value in
            value.type?.name
        }) ?? []
        pokemonImageURL = if let thumbnailPokemonImage = pokemon.sprites?.frontDefault {
            URL(string: thumbnailPokemonImage)
        } else {
            nil
        }
        backgroundImageURL = nil
        itemStyle = .normal
    }
    
    init(
        name: String,
        id: String,
        types: [String],
        pokemonImageURL: URL?,
        backgroundImageURL: URL?,
        itemStyle: PokemonCatalogItemStyle
    ) {
        self.name = name
        self.id = id
        self.types = types
        self.pokemonImageURL = pokemonImageURL
        self.backgroundImageURL = backgroundImageURL
        self.itemStyle = itemStyle
    }
}
