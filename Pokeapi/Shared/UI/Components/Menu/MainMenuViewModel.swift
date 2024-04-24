//
//  MainMenuViewModel.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation

protocol MainMenuActionHandler: AnyObject {
    func didSelect(item: MainMenuItem)
}

class MainMenuViewModel: ObservableObject {
    
    @Published
    private(set) var items: [MainMenuItem]
    
    weak var actionHandler: MainMenuActionHandler?
    
    var selectedMenuItemType: MenuItemType? {
        items.first(where: { $0.isActive })?.type
    }
    
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
    
    func select(_ selectedItem: MainMenuItem) {
        for itemIndex in 0..<items.count {
            let currentItem = items[itemIndex]
                    
            if selectedItem == currentItem {
                let updatedItem = currentItem.cloneItem(isActive: true)
                items[itemIndex] = updatedItem
                actionHandler?.didSelect(item: updatedItem)
            } else if currentItem.isActive {
                let updatedItem = currentItem.cloneItem(isActive: false)
                items[itemIndex] = updatedItem
            }
        }
    }
}
