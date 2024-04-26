//
//  PokemonDetailView.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

struct PokemonDetailView: View {
    
    @StateObject
    var viewModel: PokemonDetailViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if viewModel.isLoadingData {
                    Spacer()
                    ProgressView {
                        Text("Loading...")
                    }
                    Spacer()
                } else {
                    Text("Pokemon description")
                }
            }
        }.task {
            await viewModel.loadData()
        }.navigationTitle(viewModel.pokemonName ?? "")
    }
    
}
