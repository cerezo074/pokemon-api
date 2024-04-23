//
//  MainMenuViewModel.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation

class MainMenuViewModel: ObservableObject {
    
    @Published
    private(set) var items: [MainMenuItem]
    
    init(items: Set<MainMenuItem>) {
        self.items = Array(items.sorted(by: <))
    }
    
    func isNeededLeftSpace(for item: MainMenuItem) -> Bool {
        guard items.count > 1,
                let index = items.firstIndex(where: { $0.id == item.id }) else {
            return false
        }
        
        return index > 0
    }
        
    func isNeededRightSpace(for item: MainMenuItem) -> Bool {
        guard items.count > 1,
                let index = items.firstIndex(where: { $0.id == item.id }) else {
            return false
        }
        
        return index < (items.count - 1)
    }
    
}
