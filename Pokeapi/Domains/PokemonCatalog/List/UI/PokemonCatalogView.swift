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
    let navigator: PokemonCatalogNavigator
    @FocusState
    private var inputFocusType: InputType?
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
            
    var body: some View {
        if viewModel.isLoadingDataAtFirstTime {
            VStack {
                Spacer()
                ProgressView {
                    Text(viewModel.loaderText)
                }
                Spacer()
            }.task {
                await viewModel.viewDidAppear()
            }
        } else {
            ScrollView(.vertical) {
                let stack = VStack {
                    Text(viewModel.viewDescription)
                        .font(.headline)
                    CatalogSearchView(
                        text: $viewModel.searchText,
                        isSearching: viewModel.isSearchingPokemons,
                        placeholder: viewModel.searchPlaceholder
                    )
                    .focused($inputFocusType, equals: .filter)
                    .onSubmit {
                        inputFocusType = nil
                    }
                    if !viewModel.pokemonViewModelList.isEmpty {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.pokemonViewModelList) { pokemon in
                               makePokemonItemView(for: pokemon)
                            }
                        }
                    } else {
                        Text(viewModel.emptyListResult)
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                if #available(iOS 16.0, *) {
                    stack.navigationDestination(for: PokemonCatalogItemViewModel.self) { pokemon in
                        let newNavigator = navigator.openDetail(for: pokemon.id)
                        newNavigator.start()
                    }
                }
                
                stack
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
}

private extension PokemonCatalogView {
    
    func makePokemonItemView(for pokemon: PokemonCatalogItemViewModel) -> some View {
        //TODO: Fix wrong destination
        if #available(iOS 16.0, *) {
            return NavigationLink(
                value: pokemon
            ) {
                PokemonCatalogItemView(viewModel: pokemon)
            }.buttonStyle(PlainButtonStyle())
        } else {
            return NavigationLink {
                navigator.openDetail(for: pokemon.id).start()
            } label: {
                PokemonCatalogItemView(viewModel: pokemon)
            }.buttonStyle(PlainButtonStyle())
        }
    }
    
}

#Preview {
    NavigationView {
        let pokemonRepository = PokemonRepository(
            remoteRepository: PokemonRemoteMockRepository(),
            localRepository: PokemonLocalMockPersistence()
        )
        
        PokemonCatalogView(
            viewModel: PokemonCatalogViewModel(repository: pokemonRepository),
            navigator: PokemonCatalogNavigator(screen: .list)
        )
    }
}
