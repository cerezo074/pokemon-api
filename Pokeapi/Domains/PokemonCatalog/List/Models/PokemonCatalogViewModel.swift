//
//  PokemonCatalogViewModel.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine

class PokemonCatalogViewModel: ObservableObject {
    
    private static let retryPokemonID = "RETRY"
    private static var retryPokemonViewModel: PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel.init(
            name: Self.retryPokemonID,
            id: Self.retryPokemonID,
            types: [Self.retryPokemonID, Self.retryPokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .retry
        )
    }
    
    private static let loadMorePokemonID = "LOADING..."
    private static var loadMorePokemonViewModel: PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel(
            name: Self.loadMorePokemonID,
            id: Self.loadMorePokemonID,
            types: [Self.loadMorePokemonID, Self.loadMorePokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .load
        )
    }
 
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
    
    private var fetchPokemonTask: Task<(), Never>? = nil
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
        guard fetchPokemonTask == nil else {
            print("Fetching pokemons is on going before... no new task is needed.")
            return
        }
        
        fetchPokemonTask = Task {
            do {
                try await Task.sleep(nanoseconds: 5_000_000_000)

                let result = try await repository.loadPokemons()
                var newPokemons = result.pokemons.sorted(by: <).compactMap {
                    PokemonCatalogItemViewModel(chinpokomon: $0)
                }
                
                if result.hasMorePokemons {
                    var fakePokemon = Self.loadMorePokemonViewModel
                    
                    fakePokemon.loadMore = { [weak self] item in
                        self?.handleLoadMore(from: item)
                    }
                    
                    newPokemons.append(
                      fakePokemon
                    )
                }
                
                await updatePokemonList(with: newPokemons)
            } catch is CancellationError {
                fetchPokemonTask = nil
            } catch {
                var fakePokemon = Self.retryPokemonViewModel
                
                fakePokemon.retryTap = { [weak self] item in
                    self?.handleRetry(from: item)
                }
                
                let newPokemons = [fakePokemon]
                await updatePokemonList(with: newPokemons)
            }
        }
    }
    
    @MainActor
    private func updatePokemonList(with newPokemons: [PokemonCatalogItemViewModel]) {
        var oldPokemonList = pokemonList
        
        if let lastPokemon = oldPokemonList.last, lastPokemon.style.isRemovable {
            oldPokemonList.removeLast()
        }
        
        oldPokemonList.append(contentsOf: newPokemons)
        self.pokemonList = oldPokemonList
        self.isLoadingData = false
        self.fetchPokemonTask = nil
    }
    
    private func handleRetry(from viewModel: PokemonCatalogItemViewModel) {
        print("Retry")
    }
    
    private func handleLoadMore(from viewModel: PokemonCatalogItemViewModel) {
        fetchPokemons()
    }
}
