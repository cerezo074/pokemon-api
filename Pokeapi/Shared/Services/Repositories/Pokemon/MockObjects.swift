//
//  StubObjects.swift
//  Pokeapi
//
//  Created by eli on 26/04/24.
//

import Foundation
import PokemonAPI

struct MockObjects {
    
    static let retryPokemonID = "RETRY"
    static var retryPokemonViewModel: PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel.init(
            name: Self.retryPokemonID,
            id: Int.max,
            formattedID: Self.retryPokemonID,
            types: [Self.retryPokemonID, Self.retryPokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .retry
        )
    }

    static let loadMorePokemonID = "LOADING..."
    static var loadMorePokemonViewModel: PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel(
            name: Self.loadMorePokemonID,
            id: Int.max,
            formattedID: Self.loadMorePokemonID,
            types: [Self.loadMorePokemonID, Self.loadMorePokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .load
        )
    }
    
}

extension PKMPagedObject<PKMPokemon> {
    
    static func makePagination() -> PKMPagedObject<PKMPokemon> {
        let resourceData = """
    {
        "count": 1302,
        "next": "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
        "previous": null,
        "results": [
            {
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon/1/"
            }
        ]
    }
    """.data(using: .utf8)!
        return try! PKMPagedObject<PKMPokemon>.decode(from: resourceData)
    }
    
}
