//
//  MainMenuItem.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation

struct MainMenuItem: Hashable, Identifiable, Comparable {
    typealias ID = Int
    let id: Int
    let name: String
    let icon: String
    let isActive: Bool
    
    var type: MenuItemType? {
        MenuItemType.init(name: name)
    }
    
    func cloneItem(isActive: Bool) -> MainMenuItem {
        return MainMenuItem(id: id, name: name, icon: icon, isActive: isActive)
    }
    
    static func < (lhs: MainMenuItem, rhs: MainMenuItem) -> Bool {
        lhs.id < rhs.id
    }
}
