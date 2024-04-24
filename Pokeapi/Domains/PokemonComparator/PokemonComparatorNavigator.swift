//
//  PokemonComparatorNavigator.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI

class PokemonComparatorNavigator {
    
    @ViewBuilder
    func start() -> some View {
        ContentView()
    }
    
}

struct ContentView: View {
    let colors = [UIColor.red, .black, .blue, .brown, .gray, .green, .cyan, .magenta, .orange, .purple]
    var body: some View {
        TallVGrid(items: colors, idKeyPath: \.self, numOfColumns: 4, vSpacing: 20, content: { color in
            ColorView(uiColor: color)
            Text("Some \(Int.random(in: 0...10))")
        })
    }
}

struct TallVGrid<Item, ItemView, I>: View where ItemView: View, I: Hashable {
    var items: [Item]
    var idKeyPath: KeyPath<Item, I>
    var numOfItems : Int {
        items.count
    }
    var numOfColumns : Int = 3
    var vSpacing: CGFloat = 10
    @ViewBuilder var content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { g in
            let columns = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 100)), count: numOfColumns)
            let numOfRows: Int = Int(ceil(Double(numOfItems) / Double(numOfColumns)))
            let height: CGFloat = (g.size.height - (vSpacing * CGFloat(numOfRows - 1))) / CGFloat(numOfRows)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: vSpacing) {
                ForEach(items, id: idKeyPath) { item in
                    VStack {
                        content(item)
                    }
                    .frame(minHeight: height, maxHeight: .infinity)
                }
            }
        }
    }
}


struct ColorView: View {
    let uiColor: UIColor
    var body: some View {
        Color(uiColor)
    }
}
