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
    
    @ViewBuilder
    func start() -> some View {
        PokemonCatalogView()
    }
    
}
