//
//  MenuItemType.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation

enum MenuItemType: String {
    case home
    case comparator
    case quiz
    case favorites
    
    init?(name: String) {
        let lowercasedRawValue = name.lowercased()
        
        guard let type = MenuItemType(rawValue: lowercasedRawValue) else {
            return nil
        }
        
        self = type
    }
}
