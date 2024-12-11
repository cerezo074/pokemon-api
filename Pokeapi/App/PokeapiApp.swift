//
//  PokeapiApp.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import SwiftUI

@main
struct PokeapiApp: App {
    @StateObject private var appNavigation: AppNavigator
    
    init() {
        _appNavigation = .init(
            wrappedValue: {
                AppNavigator(
                    menuViewModel: MenuView_Previews.defaultMenuView,
                    pokemonRepository: PokemonRepository(
                        remoteRepository: PokemonRemoteRepository(),
                        localRepository: PokemonLocalRepository()
                    ),
                    userSessionManager: UserSessionProvider(),
                    userOnboardingManager: UserOnboardingProvider()
                )
        }()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            appNavigation.buildRootScreen()
        }
    }
}
