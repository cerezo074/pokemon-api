//
//  CatalogSearchView.swift
//  Pokeapi
//
//  Created by eli on 24/04/24.
//

import SwiftUI

struct CatalogSearchView: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(alignment: .top) {
          Image(systemName: "magnifyingglass")
            .resizable()
            .frame(width: 24, height: 24)
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
    CatalogSearchView(text: Binding.constant(""), placeholder: "placeholder")
}
