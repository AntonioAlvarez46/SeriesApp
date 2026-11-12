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
                .navigationTitle("Series")
                .searchable(text: $viewModel.query, prompt: "Buscar series")
                .onChange(of: viewModel.query) { _, newValue in
                    viewModel.onQueryChanged(newValue)
                }
                .navigationDestination(for: Show.self) { show in
                    ShowDetailView(viewModel: makeDetailViewModel(show))
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                "Buscar una serie",
                systemImage: "magnifyingglass",
                description: Text("Escribe el nombre de una serie")
            )
        case .loading:
            ProgressView("Buscando...")
        case .loaded(let shows):
            List(shows) { show in
                NavigationLink(value: show) {
                    ShowRowView(show: show)
                }
            }
            .listStyle(.plain)
        case .empty:
            ContentUnavailableView.search(text: viewModel.query)
        case .error(let message):
            ErrorStateView(message: message, onRetry: viewModel.retry)
        }
    }
    
}
