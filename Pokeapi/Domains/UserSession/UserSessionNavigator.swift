//
//  UserSessionNavigator.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//

import SwiftUI

protocol UserSessionUIActions: AnyObject {
    func openSignInFlow()
}

class UserSessionNavigator: ObservableObject {
    @Published
    var showSignInFlow: Bool = false
    private let userSessionManager: any UserSessionServices

    init(userSessionManager: UserSessionServices) {
        self.userSessionManager = userSessionManager
    }
    
    @ViewBuilder
    func start() -> some View {
        SignInView(userSessionManager: userSessionManager)
    }
}

extension UserSessionNavigator: UserSessionUIActions {
    
    func openSignInFlow() {
        showSignInFlow = true
    }
    
}
