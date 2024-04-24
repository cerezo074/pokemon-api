//
//  PokemonCatalogView.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import SwiftUI

struct PokemonCatalogView: View {
    
    private enum InputType {
        case filter
    }
    
    @StateObject
    var viewModel: PokemonCatalogViewModel
    @FocusState
    private var inputFocusType: InputType?
    let navigator: PokemonCatalogNavigator
        
    var body: some View {
        VStack {
            Text(viewModel.viewDescription)
                .font(.headline)
            CatalogSearchView(
                text: $viewModel.searchText,
                placeholder: viewModel.searchPlaceholder
            )
            .focused($inputFocusType, equals: .filter)
            .onSubmit {
                inputFocusType = nil
            }
            Rectangle().foregroundStyle(.red)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("Show filter screen")
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .tint(DesingSystem.Button.Color.activeColor)
                })
            }
        }
        .navigationTitle(viewModel.viewTitle)
        .onTapGesture {
            inputFocusType = nil
        }
    }
}

//            Text("Pokemon catalog screen is still under development :(")
//                .foregroundStyle(.yellow)
//            if #available(iOS 16.0, *) {
//                NavigationLink(
//                    value: PokemonCatalogNavigator(
//                        screen: .detail(pokemonName: charmandel)
//                    )
//                ) {
//                    Text("Pokemon: \(charmandel)")
//                }.navigationDestination(for: PokemonCatalogNavigator.self) { navigator in
//                    navigator.start()
//                }
//            } else {
//                NavigationLink {
//                    PokemonCatalogNavigator(
//                        screen: .detail(pokemonName: charmandel)
//                    ).start()
//                } label: {
//                    Text("Pokemon: \(charmandel)")
//                }
//            }

#Preview {
    PokemonCatalogView(
        viewModel: PokemonCatalogViewModel(),
        navigator: PokemonCatalogNavigator(screen: .list)
    )
}
