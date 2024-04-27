//
//  PokemonDetailView.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    
    @StateObject
    var viewModel: PokemonDetailViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    if viewModel.isLoadingData {
                        Spacer()
                        ProgressView {
                            Text("Loading...")
                        }
                        Spacer()
                    } else {
                        if let pokemonImage = viewModel.largeImageURL {
                            KFImage(pokemonImage)
                                .placeholder {
                                    Image("pokemon_placehoder")
                                }.resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.8)
                        }
                        
                        Group {
                            Text("Types: ")
                                .foregroundStyle(DesingSystem.Text.Color.specs1)
                            Text(viewModel.pokemonTypes.joined(separator: ", "))
                        }
                        
                        Group {
                            Text("Abilities: ")
                                .foregroundStyle(DesingSystem.Text.Color.specs2)
                            Text(viewModel.pokemonAbilities.joined(separator: ", "))
                        }
                        
                        Group {
                            Text("Moves: ")                                .foregroundStyle(DesingSystem.Text.Color.specs3)
                            Text(viewModel.pokemonMoves.joined(separator: ", "))
                        }
                    }
                }.padding(EdgeInsets.init(top: 0, leading: 20, bottom: 20, trailing: 20))
            }.task {
                await viewModel.loadData()
            }.navigationTitle(viewModel.pokemonName ?? "")
        }.frame(maxWidth: .infinity)
    }
    
}
