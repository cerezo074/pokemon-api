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
        case filter(observer: any FilterCatalogObserver)
        
        static func == (lhs: PokemonCatalogNavigator.Screen, rhs: PokemonCatalogNavigator.Screen) -> Bool {
            switch (lhs, rhs) {
            case (.list, .list): 
                return true
            case (.detail(let leftPokemonID), .detail(let rightPokemonID)):
                return leftPokemonID == rightPokemonID
            case (.filter(let leftObserver), .filter(let rightObserver)):
                return leftObserver === rightObserver
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .list:
                hasher.combine(1)
            case .detail(let pokemonID):
                hasher.combine(pokemonID)
            case .filter(let observer):
                hasher.combine(observer.id)
            }
        }
    }
    
    private var screen: Screen
    private let pokemonRepository: PokemonRepository
    private let userSessionManager: UserSessionServices
    
    init(
        screen: Screen,
        pokemonRepository: PokemonRepository? = nil,
        userSessionManager: UserSessionServices
    ) {
        self.screen = screen
        self.userSessionManager = userSessionManager
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
        
        return PokemonCatalogNavigator(
            screen: newScreen,
            pokemonRepository: pokemonRepository,
            userSessionManager: userSessionManager
        )
    }
    
    func openFilter(with observer: any FilterCatalogObserver) -> PokemonCatalogNavigator {
        let newScreen: Screen = .filter(observer: observer)
        
        return PokemonCatalogNavigator(
            screen: newScreen,
            pokemonRepository: pokemonRepository,
            userSessionManager: userSessionManager
        )
    }
    
    func openUserSession() {
        
    }

    @ViewBuilder
    private func makeScreen() -> some View {
        switch screen {
        case .list:
            let viewModel = PokemonCatalogViewModel(
                repository: pokemonRepository,
                userSessionManager: userSessionManager
            )
            
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
        case .filter(let observer):
            let viewModel = PokemonCatalogFilterViewModel(filterListerner: observer)
            PokemonCatalogFilterView(viewModel: viewModel)
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
