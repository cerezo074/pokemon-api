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
    
    init(screen: Screen) {
        self.screen = screen
    }
    
    @ViewBuilder
    func start() -> some View {
        makeScreen()
    }
    
    @ViewBuilder
    private func makeScreen() -> some View {
        switch screen {
        case .list:
            let viewModel = PokemonCatalogViewModel()
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
