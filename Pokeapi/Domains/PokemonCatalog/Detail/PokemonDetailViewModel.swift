//
//  PokemonDetailViewModel.swift
//  Pokeapi
//
//  Created by eli on 26/04/24.
//

import Foundation

class PokemonDetailViewModel: ObservableObject {
    
    var pokemonName: String? {
        return pokemon?.name.capitalized
    }
    
    var largeImageURL: URL? {
        return pokemon?.largeImageURL
    }
    
    var pokemonTypes: [String] {
        return pokemon?.types ?? []
    }
    
    var pokemonMoves: [String] {
        return pokemon?.moves ?? []
    }
    
    var pokemonAbilities: [String] {
        return pokemon?.abilities ?? []
    }
    
    private let pokemonID: Int
    private let pokemonRepository: PokemonRepository
    private var pokemon: Pokemon?
    
    @Published
    var isLoadingData: Bool
    
    init(pokemonID: Int, repository: PokemonRepository) {
        self.pokemonID = pokemonID
        self.pokemonRepository = repository
        self.isLoadingData = true
    }
    
    func loadData() async {
        do {
            let pokemon = try await pokemonRepository.getPokemon(for: pokemonID)
            self.pokemon = pokemon
            
            await MainActor.run {
                isLoadingData = false
            }
        } catch {
            print("Error getting pokemon with ID: \(pokemonID)")
        }
    }
    
}
