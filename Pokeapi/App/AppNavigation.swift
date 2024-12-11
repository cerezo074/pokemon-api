//
//  AppNavigation.swift
//  Pokeapi
//
//  Created by eli on 23/04/24.
//

import Foundation
import SwiftUI
import Combine

class AppNavigator: ObservableObject {
    
    private enum AppState {
        case showSplashScreen
        case showOnboarding
        case showHomeScreen
        case showLoginScreen
    }
    
    private let menuViewModel: MainMenuViewModel
    private let pokemonRepository: PokemonRepository
    private let userSessionManager: any UserSessionServices
    private let userOnboardingManager: any UserOnboardingServices
    private let userSessionNavigator: UserSessionNavigator
    private var subscriptions: Set<AnyCancellable> = []
    private var appState: AppState = .showSplashScreen

    init(
        menuViewModel: MainMenuViewModel,
        pokemonRepository: PokemonRepository,
        userSessionManager: any UserSessionServices,
        userOnboardingManager: any UserOnboardingServices
    ) {
        self.menuViewModel = menuViewModel
        self.userSessionManager = userSessionManager
        self.pokemonRepository = pokemonRepository
        self.userSessionNavigator = UserSessionNavigator(userSessionManager: userSessionManager)
        self.userOnboardingManager = userOnboardingManager
        menuViewModel.actionHandler = self
        
        userSessionManager.isSignedInPublisher.sink { [weak self] isUserSignedIn in
            self?.appState = isUserSignedIn ? .showHomeScreen : .showLoginScreen
            self?.objectWillChange.send()
        }.store(in: &subscriptions)
        
        userSessionManager.didLoadInitialDataPublisher.sink { [weak self] in
            self?.didLoadInitialData()
        }.store(in: &subscriptions)
    }
        
    @MainActor
    @ViewBuilder
    func buildRootScreen() -> some View {
        switch appState {
        case .showSplashScreen:
            SplashScreen(title: "Splash Screen...")
                .task {
                    await self.userSessionManager.loadData()
                }
        case .showOnboarding:
            OnboardingNavigator(didFinishOnboarding: { [weak self] in
                self?.didFinishOnboarding()
            }).start()
        case .showLoginScreen where !userSessionManager.isGuestUserAllowed:
            userSessionNavigator.start()
        case .showHomeScreen where !userSessionManager.isGuestUserAllowed:
            buildContentForSignedInUser()
        default:
            SignInModalView(userSessionNavigator: userSessionNavigator) {
                buildContentForSignedInUser()
            }
        }
    }
    
    @ViewBuilder
    private func buildContentForSignedInUser() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                buildScreenForSelectedMenuItem()
            }
        } else {
            NavigationView(content: {
                buildScreenForSelectedMenuItem()
            })
        }
    }
    
    private func buildScreenForSelectedMenuItem() -> some View {
        VStack {
            Spacer()
            buildViewForSelectedMenuItemType()
            Spacer()
            Divider()
            MenuView(viewModel: menuViewModel).frame(height: 60)
        }
    }
    
    @ViewBuilder
    private func buildViewForSelectedMenuItemType() -> some View {
        if let choice = menuViewModel.selectedMenuItemType {
            switch choice {
            case .home:
                let navigator = PokemonCatalogNavigator(
                    screen: .list,
                    pokemonRepository: pokemonRepository,
                    userSessionStateHandler: userSessionManager,
                    userSessionUIActionHandler: userSessionNavigator
                )
                
                navigator.start()
            case .comparator:
                let navigator = PokemonComparatorNavigator()
                navigator.start()
            case .quiz:
                let navigator = PokemonQuizNavigator()
                navigator.start()
            case .favorites:
                let navigator = PokemonFavoritesNavigator()
                navigator.start()
            }
        } else {
            Text("Error, view can't be build :(. Review your code")
        }
    }
    
    private func didFinishOnboarding() {
        if userSessionManager.isSignedIn || userSessionManager.isGuestUserAllowed {
            appState = .showHomeScreen
        } else {
            appState = .showLoginScreen
        }
        
        objectWillChange.send()
    }
    
    private func didLoadInitialData() {
        Task {
            if await userOnboardingManager.isOnboardingCompleted() {
                await MainActor.run {
                    didFinishOnboarding()
                }
                
                return
            }
            
            await MainActor.run {
                appState = .showOnboarding
                objectWillChange.send()
            }
        }
    }
}

extension AppNavigator: MainMenuActionHandler {
    
    func didSelect(item: MainMenuItem) {
        print("Selected menu option: \(item)")
        appState = .showHomeScreen
        objectWillChange.send()
    }
    
}
