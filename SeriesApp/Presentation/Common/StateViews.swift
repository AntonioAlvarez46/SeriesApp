//
//  StateViews.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("Algo salió mal", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Reintentar", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}
