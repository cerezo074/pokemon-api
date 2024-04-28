//
//  AppNavigation.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI
import Combine

class AppNavigator: ObservableObject {
    
    @Published
    private var menuViewModel: MainMenuViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private let pokemonRepository: PokemonRepository
    
    init(
        menuViewModel: MainMenuViewModel? = nil,
        pokemonRepository: PokemonRepository? = nil
    ) {
        let menuViewModel = MenuView_Previews.defaultMenuView
        self.menuViewModel = menuViewModel
        self.pokemonRepository = pokemonRepository ?? 
        PokemonRepository(
            remoteRepository: PokemonRemoteRepository(),
            localRepository: PokemonLocalRepository()
        )
        menuViewModel.actionHandler = self
        
        menuViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)
    }
        
    @ViewBuilder
    func buildRootScreen() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                buildScreenForSelectedMenuItem()
            }
        } else {
            NavigationView(content: {
                buildScreenForSelectedMenuItem()
            })
        }
    }
    
    @ViewBuilder
    private func buildScreenForSelectedMenuItem() -> some View {
        VStack {
            Spacer()
            buildViewForSelectedMenuItemType()
            Spacer()
            Divider()
            MenuView(viewModel: menuViewModel).frame(height: 60)
        }
    }
    
    @ViewBuilder
    private func buildViewForSelectedMenuItemType() -> some View {
        if let choice = menuViewModel.selectedMenuItemType {
            switch choice {
            case .home:
                let navigator = PokemonCatalogNavigator(
                    screen: .list,
                    pokemonRepository: pokemonRepository
                )
                navigator.start()
            case .comparator:
                let navigator = PokemonComparatorNavigator()
                navigator.start()
            case .quiz:
                let navigator = PokemonQuizNavigator()
                navigator.start()
            case .favorites:
                let navigator = PokemonFavoritesNavigator()
                navigator.start()
            }
        } else {
            Text("Error, view can't be build :(. Review your code")
        }
    }
    
}

extension AppNavigator: MainMenuActionHandler {
    
    func didSelect(item: MainMenuItem) {
        print("Selected menu option: \(item)")
    }
    
}
