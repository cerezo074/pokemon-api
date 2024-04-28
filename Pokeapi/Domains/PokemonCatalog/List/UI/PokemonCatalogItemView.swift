//
//  PokemonCatalogItemView.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct PokemonCatalogItemView: View {
    
    let viewModel: PokemonCatalogItemViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.name).font(.footnote)
                Spacer()
                Text(viewModel.formattedID).font(.footnote)
            }
            HStack {
                if viewModel.types.count > 0 {
                    VStack(spacing: 8) {
                        if let firstType = viewModel.types.first {
                            Text(firstType).font(.footnote)
                        }
                        
                        if let secondType = viewModel.secondType {
                            Text(secondType).font(.footnote)
                        }
                    }
                }
                Spacer()
                getPokemonImage()
            }
        }
        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14))
        .background(getBackgroundColor(for: viewModel.style))
        .clipShape(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
    }
}

private extension PokemonCatalogItemView {
    
    @ViewBuilder
    func getPokemonImage( ) -> some View {
        if let pokemonImageURL = viewModel.thumbnailImageURL {
            KFImage(pokemonImageURL)
                .placeholder {
                    Image("pokemon_placehoder")
                        .resizable()
                        .scaledToFill()
                }
        } else if viewModel.style == .load {
            ZStack {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 96, height: 96)
                ProgressView()
                    .tint(.white)
            }.onAppear {
                viewModel.didViewLoadMore()
            }
        } else if viewModel.style == .retry {
            ZStack {
                Rectangle()
                    .fill(Color.cyan)
                    .frame(width: 96, height: 96)
                Button {
                    viewModel.didTapRetry()
                } label: {
                    Image("pokemon_retry")
                }
            }
        }
    }

    func getBackgroundColor(for style: PokemonCatalogItemStyle) -> Color {
        switch style {
        case .load:
            return .green
        case .normal:
            return .yellow
        case .retry:
            return .red
        }
    }

}

#Preview {
    PokemonCatalogItemView(
        viewModel: PokemonCatalogItemViewModel(
            name: "Bulbasaur",
            id: 1,
            formattedID: "#001",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil,
            itemStyle: .normal
        )
    ).frame(width: 150, height: 80)
}
