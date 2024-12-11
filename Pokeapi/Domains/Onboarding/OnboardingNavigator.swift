//
//  OnboardingNavigator.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//

import SwiftUI

struct OnboardingNavigator {
    @State
    private var disableButton = false
    let didFinishOnboarding: () -> Void
    
    @ViewBuilder
    func start() -> some View {
        Text("Onboarding Screen")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, 40)
        
        Button(action: {
            didFinishOnboarding()
            disableButton = true
        }) {
            Text("Press this button to complete it.")
                .font(.callout)
                .foregroundColor(.white)
                .padding()
        }
        .background(disableButton ? Color.gray : Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .disabled(disableButton)
    }
}
