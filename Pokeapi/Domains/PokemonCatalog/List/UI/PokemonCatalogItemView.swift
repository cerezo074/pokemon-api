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
    
    let item: PokemonCatalogItemViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name).font(.footnote)
                Spacer()
                Text(item.id).font(.footnote)
            }
            HStack {
                if item.types.count > 0 {
                    VStack(spacing: 8) {
                        if let firstType = item.types.first {
                            Text(firstType).font(.footnote)
                        }
                        
                        if let secondType = item.secondType {
                            Text(secondType).font(.footnote)
                        }
                    }
                }
                Spacer()
                if let pokemonImageURL = item.pokemonImageURL {
                    KFImage(pokemonImageURL).placeholder {
                        Image("pokemon_thumbnail_placehoder")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14))
        .background(Color.yellow)
        .clipShape(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
    }
}

#Preview {
    PokemonCatalogItemView(
        item: PokemonCatalogItemViewModel(
            name: "Bulbasaur",
            id: "#001",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil,
            itemStyle: .normal
        )
    ).frame(width: 150, height: 80)
}
