//
//  PokemonCatalogFilterViewModel.swift
//  Pokeapi
//
//  Created by eli on 30/04/24.
//

import Foundation

protocol FilterCatalogObserver: AnyObject, Identifiable {
    var areFilterActives: Bool { get }
    func didChangeFilters(areFilterActives: Bool)
}

class PokemonCatalogFilterViewModel: ObservableObject {
    
    @Published
    var areFilterActives: Bool
    private unowned let filterListerner: any FilterCatalogObserver

    init(filterListerner: any FilterCatalogObserver) {
        self.filterListerner = filterListerner
        self.areFilterActives = filterListerner.areFilterActives
    }
    
    func tapOnFilter() {
        areFilterActives.toggle()
        filterListerner.didChangeFilters(areFilterActives: areFilterActives)
    }
    
}
