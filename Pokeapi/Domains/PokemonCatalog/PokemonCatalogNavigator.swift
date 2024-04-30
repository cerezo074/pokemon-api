//
//  PokemonCatalogNavigator.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

struct PokemonCatalogNavigator {
    
    enum Screen: Hashable {
        case list
        case detail(pokemonID: Int)
    }
    
    private var screen: Screen
    private let pokemonRepository: PokemonRepository
    
    init(
        screen: Screen,
        pokemonRepository: PokemonRepository? = nil
    ) {
        self.screen = screen
        self.pokemonRepository = pokemonRepository ??
        PokemonRepository(
            remoteRepository: PokemonRemoteRepository(),
            localRepository: PokemonLocalRepository()
        )
    }
    
    @ViewBuilder
    func start() -> some View {
        makeScreen()
    }
    
    func openDetail(for selectedPokemonID: Int) -> PokemonCatalogNavigator {
        let newScreen: Screen = .detail(pokemonID: selectedPokemonID)
        
        return PokemonCatalogNavigator(screen: newScreen, pokemonRepository: pokemonRepository)
    }

    @ViewBuilder
    private func makeScreen() -> some View {
        switch screen {
        case .list:
            let viewModel = PokemonCatalogViewModel(repository: pokemonRepository)
            
            if #available(iOS 16.0, *) {
                PokemonCatalogView(viewModel: viewModel, navigator: self).navigationDestination(
                    for: PokemonCatalogItemViewModel.self
                ) { pokemon in
                    let newNavigator = self.openDetail(for: pokemon.id)
                    newNavigator.start()
                }
            } else {
                PokemonCatalogView(viewModel: viewModel, navigator: self)
            }
            
        case .detail(let selectedPokemonID):
            let viewModel = PokemonDetailViewModel(pokemonID: selectedPokemonID, repository: pokemonRepository)
            PokemonDetailView(viewModel: viewModel)
        }
    }
}

extension PokemonCatalogNavigator: Hashable {
    
    static func == (lhs: PokemonCatalogNavigator, rhs: PokemonCatalogNavigator) -> Bool {
        lhs.screen == rhs.screen
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(screen)
    }
    
    var hashValue: Int {
        screen.hashValue
    }
    
}
