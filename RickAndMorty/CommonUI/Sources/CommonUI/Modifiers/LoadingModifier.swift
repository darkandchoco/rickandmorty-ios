//
//  LoadingModifier.swift
//  CommonUI
//
//  Created by Richmond and Loren on 2024-11-17.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content // Original view
                .opacity(isLoading ? 0.5 : 1) // Dim the view slightly when loading
            
            if isLoading {
                ProgressView() // The loading spinner
                    .scaleEffect(1.5) // Adjust size if needed
                    .padding()
                    .background(Color(UIColor.systemBackground).opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
    }
}

// Extension for convenience
extension View {
    func loading(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}
