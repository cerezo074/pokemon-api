//
//  MenuView.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

struct MenuView: View {
    
    @ObservedObject var viewModel: MainMenuViewModel
    
    var body: some View {
        //TODO: Support long list of items with a collection or a scrollview
        LazyHStack(spacing: 0) {
            ForEach(viewModel.items) { item in
                
                if viewModel.isNeededLeftSpace(for: item) {
                    Spacer()
                }
                
                Button(action: {
                    viewModel.select(item)
                }, label: {
                    VStack(spacing: 10) {
                        Image(systemName: item.icon)
                        Text(item.name)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(item.isActive ?
                                     DesingSystem.Button.Color.menuActiveColor : DesingSystem.Button.Color.menuInActiveColor)
                })
                .buttonStyle(.borderedProminent)
                .tint(.clear)
                
                if viewModel.isNeededRightSpace(for: item) {
                    Spacer()
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static let defaultMenuView = MainMenuViewModel(items: [
        MainMenuItem(id: 1, name: "Home", icon: "house", isActive: true),
        MainMenuItem(id: 2, name: "Comparator", icon: "arrow.left.arrow.right", isActive: false),
        MainMenuItem(id: 3, name: "Quiz", icon: "book", isActive: false),
        MainMenuItem(id: 4, name: "Favorites", icon: "heart", isActive: false)
    ])
    
    static var previews: some View {
        MenuView(viewModel: defaultMenuView)
            .frame(width: 200, height: 50)
    }
}
