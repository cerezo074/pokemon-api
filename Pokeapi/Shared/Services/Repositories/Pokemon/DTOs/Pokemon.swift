//
//  Pokemon.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

struct Pokemon: Comparable, Hashable {
    
    let id: Int
    let name: String
    let thumbnailImageURL: URL
    let largeImageURL: URL
    let types: [String]
    let moves: [String]
    let abilities: [String]
    
    init(
        id: Int,
        name: String,
        thumbnailImageURL: URL,
        largeImageURL: URL,
        types: [String],
        moves: [String],
        abilities: [String]
    ) {
        self.id = id
        self.name = name
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.types = types
        self.moves = moves
        self.abilities = abilities
    }
    
    init?(data: PKMPokemon) {
        guard let name = data.name,
              let id = data.id,
              let thumbnailImage = data.sprites?.frontDefault,
              let thumbnailImageURL = URL.init(string: thumbnailImage),
              let largeImage = data.sprites?.other?.home?.frontDefault,
              let largeImageURL = URL.init(string: largeImage),
              let pokemonTypes = data.types,
              let pokemonMoves = data.moves,
              let pokemonAbilities = data.abilities else {
            return nil
        }
        
        self.name = name
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.types = pokemonTypes.compactMap { $0.type?.name }
        self.moves = pokemonMoves.compactMap { $0.move?.name }
        self.abilities = pokemonMoves.compactMap { $0.move?.name }
    }
    
    static func < (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
