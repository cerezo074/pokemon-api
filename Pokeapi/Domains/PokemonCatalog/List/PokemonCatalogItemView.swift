//
//  PokemonCatalogItemView.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import Foundation
import SwiftUI

struct PokemonCatalogItemView: View {
    
    let item: PokemonCatalogItem
    
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
                    Rectangle()
                        .foregroundStyle(.gray)
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
        .padding(EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14))
        .background(Color.teal)
        .clipShape(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
    }
}

#Preview {
    PokemonCatalogItemView(
        item: PokemonCatalogItem(
            name: "Bulbasaur",
            id: "#001",
            types: ["Grass", "Poison"],
            pokemonImageURL: URL(string: "http://www.google.com"),
            backgroundImageURL: nil
        )
    ).frame(width: 150, height: 80)
}
