//
//  PokemonCatalogViewModel.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine

struct PokemonCatalogItem {
    let name: String
    let id: String
    let types: [String]
    let pokemonImageURL: URL?
    let backgroundImageURL: URL?
}

class PokemonCatalogViewModel: ObservableObject {
 
    @Published
    var pokemonList: [PokemonCatalogItem] = []
    
    @Published
    var isLoadingData: Bool = false
    
    @Published
    var searchText: String = ""
    
    var viewTitle: String {
        return "Pokédex"
    }
    
    var viewDescription: String {
        return "Use the advanced search to find Pokemon by type, weakness, ability and more!"
    }
    
    var searchPlaceholder: String {
        return "Search a pokémon"
    }
    
}
