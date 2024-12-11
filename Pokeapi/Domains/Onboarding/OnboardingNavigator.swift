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
        Button(action: {
            didFinishOnboarding()
            disableButton = true
        }) {
            Text("Onboarding Screen, press this button to finish it")
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
