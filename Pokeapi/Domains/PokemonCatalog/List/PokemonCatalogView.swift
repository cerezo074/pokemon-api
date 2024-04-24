//
//  PokemonCatalogView.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import SwiftUI

struct PokemonCatalogView: View {
    
    let navigator: PokemonCatalogNavigator
    private let charmandel: String = "Charmandel"
    
    var body: some View {
        VStack {
            Text("Pokemon catalog screen is still under development :(")
                .foregroundStyle(.yellow)
            if #available(iOS 16.0, *) {
                NavigationLink(
                    value: PokemonCatalogNavigator(
                        screen: .detail(pokemonName: charmandel)
                    )
                ) {
                    Text("Pokemon: \(charmandel)")
                }.navigationDestination(for: PokemonCatalogNavigator.self) { navigator in
                    navigator.start()
                }
            } else {
                NavigationLink {
                    PokemonCatalogNavigator(
                        screen: .detail(pokemonName: charmandel)
                    ).start()
                } label: {
                    Text("Pokemon: \(charmandel)")
                }
            }
        }
    }
}

#Preview {
    PokemonCatalogView(
        navigator: PokemonCatalogNavigator(screen: .list)
    )
}
