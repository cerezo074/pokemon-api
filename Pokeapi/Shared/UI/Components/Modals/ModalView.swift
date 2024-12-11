//
//  ModalView.swift
//  Pokeapi
//
//  Created by Eli Pacheco Hoyos on 11/12/24.
//

import SwiftUI

struct ModalView<MainContent: View, ModalContent: View>: View {
    
    private let mainContent: MainContent
    private let modalContent: ModalContent
    @Binding
    private var showModal: Bool
    
    init(
        showModal: Binding<Bool>,
        @ViewBuilder mainContent: () -> MainContent,
        @ViewBuilder modalContent: () -> ModalContent
    ) {
        self._showModal = showModal
        self.mainContent = mainContent()
        self.modalContent = modalContent()
    }
    
    var body: some View {
        mainContent
            .fullScreenCover(isPresented: $showModal) {
                modalContent
            }
    }
}
