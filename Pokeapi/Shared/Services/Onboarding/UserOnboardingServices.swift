//
//  UserOnboardingServices.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//

import Foundation

protocol UserOnboardingServices {
    func isOnboardingCompleted() async -> Bool
}

class UserOnboardingProvider: UserOnboardingServices {
    func isOnboardingCompleted() async -> Bool {
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        // TODO: Inject and use User Default
        return true
    }
}
