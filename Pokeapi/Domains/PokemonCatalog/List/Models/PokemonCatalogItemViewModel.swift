//
//  PokemonCatalogItemViewModel.swift
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

class PokemonCatalogItemViewModel: Hashable, Identifiable {
    typealias ActionCallback = (PokemonCatalogItemViewModel) -> Void
    typealias ID = Int
    let name: String
    let id: Int
    let formattedID: String
    let types: [String]
    let pokemonImageURL: URL?
    let backgroundImageURL: URL?
    let style: PokemonCatalogItemStyle
    
    var retryTap: ActionCallback? = nil
    var loadMore: ActionCallback? = nil
    
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
        id = pokemonID
        formattedID = "#\(pokemonID)"
        types = pokemon.types?.compactMap({ value in
            value.type?.name
        }) ?? []
        pokemonImageURL = if let thumbnailPokemonImage = pokemon.sprites?.frontDefault {
            URL(string: thumbnailPokemonImage)
        } else {
            nil
        }
        backgroundImageURL = nil
        style = .normal
    }
    
    init(
        name: String,
        id: Int,
        formattedID: String,
        types: [String],
        pokemonImageURL: URL?,
        backgroundImageURL: URL?,
        itemStyle: PokemonCatalogItemStyle
    ) {
        self.name = name
        self.id = id
        self.formattedID = formattedID
        self.types = types
        self.pokemonImageURL = pokemonImageURL
        self.backgroundImageURL = backgroundImageURL
        self.style = itemStyle
    }
    
    func didTapRetry() {
        guard style == .retry else {
            return
        }
        
        retryTap?(self)
    }
    
    func didViewLoadMore() {
        guard style == .load else {
            return
        }
        
        loadMore?(self)
    }
    
    static func == (lhs: PokemonCatalogItemViewModel, rhs: PokemonCatalogItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
