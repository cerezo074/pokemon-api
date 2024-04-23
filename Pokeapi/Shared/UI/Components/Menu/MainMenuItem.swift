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
    
    static func < (lhs: MainMenuItem, rhs: MainMenuItem) -> Bool {
        lhs.id < rhs.id
    }
}
