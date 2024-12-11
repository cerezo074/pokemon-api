//
//  UserSessionProvider.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 10/12/24.
//

import Combine
import Foundation

protocol UserSessionServices {
    var isGuestUserAllowed: Bool { get }
    var isSignedIn: Bool { get }
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var didLoadInitialDataPublisher: AnyPublisher<Void, Never> { get }
    func signIn() async
    func signOut() async
    func loadData() async
}

class UserSessionProvider: UserSessionServices {
    let isGuestUserAllowed: Bool = true

    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        isSignedInSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var didLoadInitialDataPublisher: AnyPublisher<Void, Never> {
        didLoadInitialDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private(set) var isSignedIn: Bool = false
    private var didLoadInitialData: Bool = false
    private let didLoadInitialDataSubject: PassthroughSubject<Void, Never> = .init()
    private let isSignedInSubject: PassthroughSubject<Bool, Never> = .init()
    
    func signIn() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        isSignedInSubject.send(true)
    }
    
    func signOut() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        isSignedInSubject.send(false)
    }
    
    func loadData() async {
        guard !didLoadInitialData else { return }
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        didLoadInitialDataSubject.send()
        didLoadInitialData = true
    }
}
