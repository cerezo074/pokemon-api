//
//  Chinpokomon.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

struct Chinpokomon: Comparable, Hashable {
    //TODO: Get rid of this huge entity and use what is really necessary
    let data: PKMPokemon
    let largeImage: URL?
    
    var pokemonThumbnailImageURL: URL? {
        guard let frontDefaultImage = data.sprites?.frontDefault else {
            return nil
        }
        
        return URL.init(string: frontDefaultImage)
    }
    
    static func < (lhs: Chinpokomon, rhs: Chinpokomon) -> Bool {
        (lhs.data.id ?? -1) < (rhs.data.id ?? -1)
    }
    
    static func == (lhs: Chinpokomon, rhs: Chinpokomon) -> Bool {
        lhs.data.id == rhs.data.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data.id)
    }
}
