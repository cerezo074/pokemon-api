//
//  PokemonCatalogViewModel.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine

class PokemonCatalogViewModel: ObservableObject {
    
    private static let pokemonLoaderItemID = "LOADING..."
    private static let pokemonRetryItemID = "RETRY"
 
    @Published
    var pokemonList: [PokemonCatalogItemViewModel]
    
    @Published
    var isLoadingData: Bool
    
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
    
    private var didViewLoad: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.pokemonList = []
        self.repository = repository
        isLoadingData = true
    }
    
    func viewDidAppear() {
        guard !didViewLoad else {
            return
        }
        didViewLoad = true
        isLoadingData = true

        fetchPokemons()
    }
    
    func loadMorePokemons() {
        fetchPokemons()
    }
    
    private func fetchPokemons() {
        Task {
            do {
                let result = try await repository.loadPokemons()
                var newPokemons = result.pokemons.sorted(by: <).compactMap {
                    PokemonCatalogItemViewModel(chinpokomon: $0)
                }
                
                if result.hasMorePokemons {
                    newPokemons.append(
                        PokemonCatalogItemViewModel.init(
                            name: Self.pokemonLoaderItemID,
                            id: Self.pokemonLoaderItemID,
                            types: [Self.pokemonLoaderItemID, Self.pokemonLoaderItemID],
                            pokemonImageURL: nil,
                            backgroundImageURL: nil,
                            itemStyle: .load
                        )
                    )
                }
                
                await updatePokemonList(with: newPokemons)
            } catch {
                let newPokemons = [
                    PokemonCatalogItemViewModel.init(
                        name: Self.pokemonRetryItemID,
                        id: Self.pokemonRetryItemID,
                        types: [Self.pokemonRetryItemID, Self.pokemonRetryItemID],
                        pokemonImageURL: nil,
                        backgroundImageURL: nil,
                        itemStyle: .retry
                    )
                ]
                
                await updatePokemonList(with: newPokemons)
            }
        }
    }
    
    @MainActor
    private func updatePokemonList(with newPokemons: [PokemonCatalogItemViewModel]) {
        var oldPokemonList = pokemonList
        
        if let lastPokemon = oldPokemonList.last, lastPokemon.itemStyle.isRemovable {
            oldPokemonList.removeLast()
        }
        
        oldPokemonList.append(contentsOf: newPokemons)
        self.pokemonList = oldPokemonList
        self.isLoadingData = false
    }
}
