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
            Label(L10n.Common.errorTitle, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(L10n.Common.retry, action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}
