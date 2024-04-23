//
//  AppNavigation.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

class AppNavigator: ObservableObject {
    
    private lazy var catalogNavigation: PokemonCatalogNavigator = {
        let navigator = PokemonCatalogNavigator()
        
        return navigator
    }()
    
        
    @ViewBuilder
    func buildRootScreen() -> some View {
        catalogNavigation.start()
    }
    
}

extension AppNavigator: PokemonCatalogExternalNavigation {
    
}
