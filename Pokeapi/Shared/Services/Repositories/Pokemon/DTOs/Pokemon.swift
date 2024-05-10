//
//  Pokemon.swift
//  Pokeapi
//
//  Created by eli on 25/04/24.
//

import Foundation
import PokemonAPI

struct Pokemon: Comparable, Hashable, Codable {
    
    let id: Int
    let name: String
    let thumbnailImageURL: URL
    let largeImageURL: URL
    let types: [PokemonMetaData]
    let moves: [PokemonMetaData]
    let abilities: [PokemonMetaData]
    
    init(
        id: Int,
        name: String,
        thumbnailImageURL: URL,
        largeImageURL: URL,
        types: [PokemonMetaData],
        moves: [PokemonMetaData],
        abilities: [PokemonMetaData]
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
        self.moves = pokemonMoves.compactMap {
            $0.move?.makePokemonMetadata()
        }
        self.types = pokemonTypes.compactMap {
            $0.type?.makePokemonMetadata()
        }
        self.abilities = pokemonAbilities.compactMap {
            $0.ability?.makePokemonMetadata()
        }
    }
    
    init?(data: CDPokemon) {
        guard let name = data.name,
              let thumbnailImageURL = data.thumbnailImageURL,
              let largeImageURL = data.largeImageURL else {
                  return nil
              }
        
        self.name = name
        self.id = Int(data.id)
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.moves = data.makeMovesMedatata()
        self.types = data.makeTypesMedatata()
        self.abilities = data.makeAbilitiesMedatata()
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

struct PokemonMetaData: Equatable, Identifiable, Codable {
    typealias ID = Int
    let id: Int
    let value: String
    
    init(id: Int, value: String) {
        self.id = id
        self.value = value
    }
    
    init?(urlString: String?, name: String?) {
        guard let name,
              let rawURL = urlString,
              let StringID = URL(string: rawURL)?.lastPathComponent,
              let id = Int(StringID) else {
            return nil
        }
        
        self.id = id
        self.value = name
    }
}

extension PKMNamedAPIResource {
    
    func makePokemonMetadata() -> PokemonMetaData? {
        return PokemonMetaData(urlString: url, name: name)
    }
    
}

extension CDPokemon {
    
    func makeTypesMedatata() -> [PokemonMetaData] {
        guard let types else { return [] }
        
        return types.compactMap {
            $0 as? CDType
        }.compactMap { item -> PokemonMetaData? in
            guard let name = item.name else {
                return nil
            }
            
            return PokemonMetaData(id: Int(item.id), value: name)
        }
    }
    
    func makeAbilitiesMedatata() -> [PokemonMetaData] {
        guard let abilities else { return [] }
        
        return abilities.compactMap {
            $0 as? CDAbility
        }.compactMap { item -> PokemonMetaData? in
            guard let name = item.name else {
                return nil
            }
            
            return PokemonMetaData(id: Int(item.id), value: name)
        }
    }
    
    func makeMovesMedatata() -> [PokemonMetaData] {
        guard let moves else { return [] }
        
        return moves.compactMap {
            $0 as? CDMove
        }.compactMap { item -> PokemonMetaData? in
            guard let name = item.name else {
                return nil
            }
            
            return PokemonMetaData(id: Int(item.id), value: name)
        }
    }
}
