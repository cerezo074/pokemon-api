//
//  UserSessionNavigator.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//

import SwiftUI

class UserSessionNavigator: ObservableObject {
    private let userSessionManager: any UserSessionServices

    init(userSessionManager: UserSessionServices) {
        self.userSessionManager = userSessionManager
    }
    
    @ViewBuilder
    func start() -> some View {
        SignInView(userSessionManager: userSessionManager)
    }
}

struct SignInView: View {
    @Environment(\.dismiss)
    private var dismiss
    @State
    private var disableButton: Bool = false
    
    let userSessionManager: any UserSessionServices
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login Screen...")
                .font(.title2)
                .padding(.bottom, 40)
            
            Button(action: {
                disableButton = true
                
                Task {
                    await self.userSessionManager.signIn()
                }
            }) {
                Text("Tap to sign in")
                    .font(.callout)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(disableButton ? Color.gray : Color.brown)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .disabled(disableButton)
                      
            if userSessionManager.isGuestUserAllowed {
                Button(action: {
                    dismiss.callAsFunction()
                }) {
                    Text("Tap to dismiss")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.brown)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
        }
    }
}
