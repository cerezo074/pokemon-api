//
//  PokemonDetailViewModel.swift
//  Pokeapi
//
//  Created by eli on 26/04/24.
//

import Foundation

class PokemonDetailViewModel: ObservableObject {
    
    var pokemonName: String? {
        return pokemon?.data.name?.capitalized
    }
    
    var largeImageURL: URL? {
        return pokemon?.largeImage
    }
    
    var pokemonTypes: [String] {
        guard let types = pokemon?.data.types else {
            return []
        }
        
        return types.compactMap { $0.type?.name }
    }
    
    var pokemonMoves: [String] {
        guard let moves = pokemon?.data.moves else {
            return []
        }
        
        return moves.compactMap { $0.move?.name }
    }
    
    var pokemonAbilities: [String] {
        guard let abilities = pokemon?.data.abilities else {
            return []
        }
        
        return abilities.compactMap { $0.ability?.name }
    }
    
    private let pokemonID: Int
    private let pokemonRepository: PokemonRepository
    private var pokemon: Chinpokomon?
    
    @Published
    var isLoadingData: Bool
    
    init(pokemonID: Int, repository: PokemonRepository) {
        self.pokemonID = pokemonID
        self.pokemonRepository = repository
        self.isLoadingData = true
    }
    
    func loadData() async {
        do {
            let pokemon = try await pokemonRepository.getPokemon(at: pokemonID)
            self.pokemon = pokemon
            
            await MainActor.run {
                isLoadingData = false
            }
        } catch {
            print("Error getting pokemon with ID: \(pokemonID)")
        }
    }
    
}
