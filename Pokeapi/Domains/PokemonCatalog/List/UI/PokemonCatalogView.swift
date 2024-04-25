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
        if viewModel.isLoadingData {
            VStack {
                Spacer()
                ProgressView {
                    Text(viewModel.loaderText)
                }
                Spacer()
            }.onAppear(perform: {
                viewModel.viewDidAppear()
            })
        } else {
            ScrollView(.vertical) {
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
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.pokemonList) { pokemon in
                            PokemonCatalogItemView(viewModel: pokemon)
                        }
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
    NavigationView {
        let pokemonRepository = PokemonRepository(
            remoteRepository: PokemonRemoteMockDataRepository()
        )
        
        PokemonCatalogView(
            viewModel: PokemonCatalogViewModel(repository: pokemonRepository),
            navigator: PokemonCatalogNavigator(screen: .list)
        )
    }
}

class PokemonRemoteMockDataRepository: PokemonRemoteDataServices {
    
    func load() async throws -> PokemonFetchDataResult {
        return .init(pokemons: [], hasMorePokemons: false)
    }
    
}
