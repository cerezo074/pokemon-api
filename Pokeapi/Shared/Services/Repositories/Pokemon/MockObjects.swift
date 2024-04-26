//
//  StubObjects.swift
//  Pokeapi
//
//  Created by eli on 26/04/24.
//

import Foundation
import PokemonAPI

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
