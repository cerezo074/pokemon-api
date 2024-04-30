//
//  PokemonCatalogFilterView.swift
//  Pokeapi
//
//  Created by eli on 30/04/24.
//

import SwiftUI

struct PokemonCatalogFilterView: View {
    
    @StateObject
    var viewModel: PokemonCatalogFilterViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.tapOnFilter()
            } label: {
                Text("Tap to activate/deactivate filters")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(
                viewModel.areFilterActives ?
                DesingSystem.Button.Color.navigationActiveColor :
                    DesingSystem.Button.Color.navigationInActiveColor
            )
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
}
