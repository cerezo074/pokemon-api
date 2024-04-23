//
//  PokeapiApp.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import SwiftUI

@main
struct PokeapiApp: App {
    @StateObject var appNavigation = AppNavigator()
    
    var body: some Scene {
        WindowGroup {
            appNavigation.buildRootScreen()
        }
    }
}
