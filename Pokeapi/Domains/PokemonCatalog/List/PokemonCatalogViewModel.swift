//
//  PokemonCatalogViewModel.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine

class PokemonCatalogViewModel: ObservableObject {
 
    @Published
    var pokemonList: [PokemonCatalogItem] = [
        PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#001",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        ),
        PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#002",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        ),
        PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#003",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        ),
        PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#004",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        ),PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#005",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        )
    ]
    
    @Published
    var isLoadingData: Bool = false
    
    @Published
    var searchText: String = ""
    
    var loaderText: String {
        return "Loading your pokémons..."
    }
    
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
