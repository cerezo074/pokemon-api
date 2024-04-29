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
                VStack {
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
                            ForEach(viewModel.pokemonViewModelList, id: \.id) { pokemon in
                                makePokemonItemView(for: pokemon)
                            }
                        }
                    } else {
                        Text(viewModel.emptyListResult)
                    }
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
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
    
    @ViewBuilder
    func makePokemonItemView(for pokemon: PokemonCatalogItemViewModel) -> some View {
        if pokemon.isAllowedToShowDetail {
            if #available(iOS 16.0, *) {
                NavigationLink(
                    value: pokemon
                ) {
                    PokemonCatalogItemView(viewModel: pokemon)
                }.buttonStyle(PlainButtonStyle())
            } else {
                NavigationLink {
                    navigator.openDetail(for: pokemon.id).start()
                } label: {
                    PokemonCatalogItemView(viewModel: pokemon)
                }.buttonStyle(PlainButtonStyle())
            }
        } else {
            PokemonCatalogItemView(viewModel: pokemon).onTapGesture {
                pokemon.didTap()
            }
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
