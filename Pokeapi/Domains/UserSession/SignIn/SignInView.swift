//
//  SignInView.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 11/12/24.
//

import SwiftUI

// TODO: Extract format and business logic into a view model.

struct SignInView: View {
    @Environment(\.dismiss)
    private var dismiss
    @State
    private var showLoader: Bool = false
    
    let userSessionManager: any UserSessionServices
    
    var body: some View {
        VStack(spacing: 20) {
            Text("User Session Screen")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            if !showLoader, let welcomeMessage {
                Text(welcomeMessage)
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.bottom, 20)
            }
            
            if showLoader {
                ProgressView("Wait a moment ...")
            } else {
                mainButton
                          
                if userSessionManager.isGuestUserAllowed {
                    dismissButton
                }
            }
        }
    }
    
    private var welcomeMessage: String? {
        if userSessionManager.isSignedIn {
            return "Welcome registered user!"
        }
        
        if userSessionManager.isGuestUserAllowed {
            return "Welcome guest user!"
        }
        
        return nil
    }
    
    private var mainButton: some View {
        Button(action: {
            showLoader = true
            
            Task {
                if userSessionManager.isSignedIn {
                    await self.userSessionManager.signOut() { self.dismiss.callAsFunction() }
                } else {
                    await self.userSessionManager.signIn() { self.dismiss.callAsFunction() }
                }
            }
        }) {
            Text("Tap to Sign \(userSessionManager.isSignedIn ? "Out" : "In")")
                .font(.callout)
                .foregroundColor(.white)
                .padding()
        }
        .background(Color.brown)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    private var dismissButton: some View {
        Button(action: {
            dismiss.callAsFunction()
        }) {
            Text("Tap to dismiss")
                .font(.callout)
                .foregroundColor(.white)
                .padding()
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}
