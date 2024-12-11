//
//  SignInModalView.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 11/12/24.
//

import SwiftUI

struct SignInModalView<MainContent: View>: View {
    private let mainContent: MainContent
    @ObservedObject
    private var userSessionNavigator: UserSessionNavigator
    
    init(
        userSessionNavigator: UserSessionNavigator,
        @ViewBuilder mainContent: () -> MainContent
    ) {
        self.userSessionNavigator = userSessionNavigator
        self.mainContent = mainContent()
    }
    
    var body: some View {
        ModalView(
            showModal: $userSessionNavigator.showSignInFlow) {
                mainContent
            } modalContent: {
                userSessionNavigator.start()
            }
    }
}
