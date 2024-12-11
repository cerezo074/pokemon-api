//
//  SplashScreen.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//
import SwiftUI

struct SplashScreen: View {
    let title: String
    @State private var animate = false

    var body: some View {
        VStack {
            Spacer()

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .opacity(animate ? 1.0 : 0.5)
                .scaleEffect(animate ? 1.2 : 0.8)
                .onAppear {
                    startAnimation()
                }
                .animation(
                    .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: animate
                )

            Spacer()
        }
    }

    private func startAnimation() {
        animate = true
    }
}
