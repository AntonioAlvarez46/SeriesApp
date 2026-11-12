//
//  SearchView.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    private let makeDetailViewModel: (Show) -> ShowDetailViewModel
    
    init(viewModel: SearchViewModel, makeDetailViewModel: @escaping (Show) -> ShowDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
        self.makeDetailViewModel = makeDetailViewModel
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Search.title)
                .searchable(text: $viewModel.query, prompt: L10n.Search.prompt)
                .onChange(of: viewModel.query) { _, newValue in
                    viewModel.onQueryChanged(newValue)
                }
                .navigationDestination(for: Show.self) { show in
                    ShowDetailView(viewModel: makeDetailViewModel(show))
                }
        }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                L10n.Search.idleTitle,
                systemImage: "magnifyingglass",
                description: Text(L10n.Search.idleDescription)
            )
        case .loading:
            ProgressView(L10n.Search.loading)
        case .loaded(let shows):
            List(shows) { show in
                NavigationLink(value: show) {
                    ShowRowView(show: show)
                }
            }
            .listStyle(.plain)
        case .empty:
            ContentUnavailableView(
                L10n.Search.emptyTitle,
                systemImage: "magnifyingglass",
                description: Text(L10n.Search.emptyDescription(viewModel.query))
            )
        case .error(let message):
            ErrorStateView(message: message, onRetry: viewModel.retry)
        }
    }
    
}
