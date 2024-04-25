//
//  PokemonCatalogNavigator.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

protocol PokemonCatalogExternalNavigation {
    
}

class PokemonCatalogNavigator {
    
    enum Screen: Hashable {
        case list
        case detail(pokemonName: String)
    }
    
    private var screen: Screen
    private let pokemonRepository: PokemonRepository
    
    init(screen: Screen, pokemonRepository: PokemonRepository? = nil) {
        self.screen = screen
        self.pokemonRepository = pokemonRepository ?? PokemonRepository(remoteRepository: PokemonRemoteRepository())
    }
    
    @ViewBuilder
    func start() -> some View {
        makeScreen()
    }
    
    @ViewBuilder
    private func makeScreen() -> some View {
        switch screen {
        case .list:
            let viewModel = PokemonCatalogViewModel(repository: pokemonRepository)
            PokemonCatalogView(viewModel: viewModel, navigator: self)
        case .detail(let pokemonName):
            PokemonDetailView(pokemonName: pokemonName)
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
