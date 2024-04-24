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
    
    private lazy var catalogNavigator: PokemonCatalogNavigator = {
        let navigator = PokemonCatalogNavigator()
        
        return navigator
    }()
    
    private lazy var comparatorNavigator: PokemonComparatorNavigator = {
        let navigator = PokemonComparatorNavigator()
        
        return navigator
    }()
    
    private lazy var quizNavigator: PokemonQuizNavigator = {
        let navigator = PokemonQuizNavigator()
        
        return navigator
    }()
    
    private lazy var favoritesNavigator: PokemonFavoritesNavigator = {
        let navigator = PokemonFavoritesNavigator()
        
        return navigator
    }()
    
    @Published
    private var menuViewModel: MainMenuViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(menuViewModel: MainMenuViewModel? = nil) {
        let menuViewModel = MenuView_Previews.defaultMenuView
        self.menuViewModel = menuViewModel
        menuViewModel.actionHandler = self
        
        menuViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)
    }
        
    @ViewBuilder
    func buildRootScreen() -> some View {
        NavigationView(content: {
            VStack {
                Spacer()
                buildViewForSelectedMenuItemType()
                Spacer()
                MenuView(viewModel: menuViewModel).frame(height: 60)
            }
        })
    }
    
    @ViewBuilder
    private func buildViewForSelectedMenuItemType() -> some View {
        if let choice = menuViewModel.selectedMenuItemType {
            switch choice {
            case .home:
                catalogNavigator.start()
            case .comparator:
                comparatorNavigator.start()
            case .quiz:
                quizNavigator.start()
            case .favorites:
                favoritesNavigator.start()
            }
        } else {
            Text("Error, view can't be build :(. Review your code")
        }
    }
    
}

extension AppNavigator: MainMenuActionHandler {
    
    func didSelect(item: MainMenuItem) {
        
    }
    
}
