//
//  PokemonCatalogViewModel.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import Combine

class PokemonCatalogViewModel: ObservableObject {
 
    @Published
    var pokemonViewModelList: [PokemonCatalogItemViewModel]
    
    @Published
    var isLoadingDataAtFirstTime: Bool
    
    @Published
    var searchText: String = ""
    
    @Published
    var isSearchingPokemons: Bool
    
    let loaderText: String = "Loading your pokémons..."
    let viewTitle: String = "Pokédex"
    let emptyListResult: String = "We couldn't find pokemons :("
    let viewDescription: String = "Use the advanced search to find Pokemon by type, weakness, ability and more!"
    let searchPlaceholder: String = "Search a pokémon"
    private var pokemonList: [PokemonCatalogItemViewModel] = []
    private var fetchPokemonTask: Task<(), Never>? = nil
    private var didViewLoad: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private let repository: PokemonRepository
    private let seachTextUpdateTime: Double = 3
    
    init(repository: PokemonRepository) {
        self.pokemonViewModelList = []
        self.repository = repository
        isSearchingPokemons = false
        isLoadingDataAtFirstTime = true
        
        $searchText
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSearchingPokemons = true
            })
            .throttle(for: .seconds(seachTextUpdateTime), scheduler: DispatchQueue.global(), latest: true)
            .sink { [weak self] word in
                self?.filterPokemons(by: word.lowercased())
        }.store(in: &cancellables)
    }
    
    func viewDidAppear() async {
        guard !didViewLoad else {
            return
        }
        
        didViewLoad = true
        await MainActor.run {
            isLoadingDataAtFirstTime = true
        }

        do {
            if let (fetchedPokemons, hasMorePokemons) = try await repository.loadInitialState() {
                await updateView(with: fetchedPokemons, with: hasMorePokemons)
                return
            }
        } catch {
            print("Error loading initial state \(error.localizedDescription)")
        }
        
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
                let (fetchedPokemons, hasMorePokemons) = try await repository.loadPokemons()
                await updateView(with: fetchedPokemons, with: hasMorePokemons)
            } catch is CancellationError {
                fetchPokemonTask = nil
            } catch {
                let fakePokemon = MockObjects.retryPokemonViewModel
                
                fakePokemon.retryTap = { [weak self] item in
                    self?.handleRetry(from: item)
                }
                
                let newPokemons = [fakePokemon]
                await updatePokemonList(with: newPokemons)
            }
        }
    }
    
    private func updateView(with fetchedPokemons: [Pokemon], with hasMorePokemons: Bool) async {
        var newPokemons = fetchedPokemons.sorted(by: <).compactMap {
            PokemonCatalogItemViewModel(pokemon: $0)
        }
                
        if hasMorePokemons {
            let fakePokemon = MockObjects.loadMorePokemonViewModel
            
            fakePokemon.loadMore = { [weak self] item in
                self?.handleLoadMore(from: item)
            }
            
            newPokemons.append(
              fakePokemon
            )
        }
        
        await updatePokemonList(with: newPokemons)
    }
    
    @MainActor
    private func updatePokemonList(with newPokemons: [PokemonCatalogItemViewModel]) {
        var oldPokemonList = pokemonList
        
        if let lastPokemon = oldPokemonList.last, lastPokemon.style.isRemovable {
            oldPokemonList.removeLast()
        }
        
        oldPokemonList.append(contentsOf: newPokemons)
        self.pokemonList = oldPokemonList
        self.pokemonViewModelList = pokemonList
        self.isLoadingDataAtFirstTime = false
        self.fetchPokemonTask = nil
    }
    
    private func handleRetry(from viewModel: PokemonCatalogItemViewModel) {
        print("Retry")
    }
    
    private func handleLoadMore(from viewModel: PokemonCatalogItemViewModel) {
        fetchPokemons()
    }
    
    private func filterPokemons(by word: String) {
        let isFilterEnabled = !word.isEmpty
        let filteredItems: [PokemonCatalogItemViewModel]
        
        if (isFilterEnabled) {
            filteredItems = pokemonList.compactMap { item in
                //TODO: Improve with a better approach NSPredicate or Regex
                guard item.style == .normal, item.name.contains(word) else {
                    return nil
                }
                
                return item
            }
            
        } else {
            filteredItems = pokemonList
        }
        
        Task {
            await MainActor.run {
                isSearchingPokemons = false
                pokemonViewModelList = filteredItems
            }
        }
    }
}
