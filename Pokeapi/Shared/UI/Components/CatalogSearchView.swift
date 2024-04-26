//
//  CatalogSearchView.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import SwiftUI

struct CatalogSearchView: View {
    
    @Binding var text: String
    let isSearching: Bool
    let placeholder: String
    
    var body: some View {
        HStack(alignment: .top) {
            if isSearching {
                HStack {
                    ProgressView()
                    Spacer().frame(width: 10)
                }
            } else {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
          TextField(placeholder, text: $text)
        }
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 1)
        )
        .padding()
    }
    
}

#Preview {
    CatalogSearchView(text: Binding.constant(""), isSearching: false, placeholder: "placeholder")
}
