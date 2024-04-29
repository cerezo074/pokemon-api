//
//  PokemonAPIPagination.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation
import PokemonAPI

struct PokemonAPIPagination: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let current: String
    let results: [Dictionary<String, String>]
    let limit: Int
    let offset: Int
    
    init(from PKMPagination: PKMPagedObject<PKMPokemon>) {
        self.count = PKMPagination.count
        self.next = PKMPagination.next
        self.previous = PKMPagination.previous
        self.current = PKMPagination.current
        self.limit = PKMPagination.limit
        self.offset = PKMPagination.offset
        
        if let results = PKMPagination.results {
            self.results = results.compactMap({ result -> Dictionary<String, String>? in
                guard let namedAPIResult = result as? PKMNamedAPIResource<PKMPokemon>,
                      let name = namedAPIResult.name,
                      let url = namedAPIResult.url else {
                    return nil
                }
                
                return ["name": name, "url": url]
            })
        } else {
            results = []
        }
        
    }
    
    init(
        count: Int?,
        next: String?,
        previous: String?,
        current: String,
        results: [Dictionary<String, String>],
        limit: Int,
        offset: Int
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.current = current
        self.results = results
        self.limit = limit
        self.offset = offset
    }
    
    func makePKMPagination() -> PKMPagedObject<PKMPokemon> {
        let PKMResults: [PKMNamedAPIResource<PKMPokemon>] = results.map {
            PKMNamedAPIResource<PKMPokemon>.init(name: $0["name"], url: $0["url"])
        }
        
        return PKMPagedObject(
            count: count,
            next: next,
            previous: previous,
            current: current,
            results: PKMResults,
            limit: limit,
            offset: offset
        )
    }
}
