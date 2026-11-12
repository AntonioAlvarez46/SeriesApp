//
//  SearchViewModel.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    
    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case loaded([Show])
        case empty
        case error(String)
    }
    
    // MARK: - Properties
    var query = ""
    private(set) var state: State = .idle
    private(set) var searchTask: Task<Void, Never>?
    private let searchShowsUseCase: SearchShowsUseCase
    private let debounce: Duration
    
    // MARK: - Init
    init(searchShowsUseCase: SearchShowsUseCase, debounce: Duration = .milliseconds(400)) {
        self.searchShowsUseCase = searchShowsUseCase
        self.debounce = debounce
    }
    
    // MARK: - Public API
    func onQueryChanged(_ newQuery: String) {
        searchTask?.cancel()
        guard !newQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .idle
            return
        }
        
        searchTask = Task { [weak self] in
            await self?.performSearch(query: newQuery)
        }
    }
    
    func retry() {
        onQueryChanged(query)
    }
    
    // MARK: - Private
    private func performSearch(query: String) async {
        do {
            try await Task.sleep(for: debounce)
        } catch {
            return
        }
        
        state = .loading
        
        do {
            let shows = try await searchShowsUseCase.execute(query: query)
            guard !Task.isCancelled else { return }
            state = shows.isEmpty ? .empty : .loaded(shows)
        } catch {
            guard !Task.isCancelled, !Self.isCancellation(error) else { return }
            state = .error(L10n.Search.errorMessage)
        }
    }
    
    private static func isCancellation(_ error: Error) -> Bool {
        error is CancellationError || (error as? URLError)?.code == .cancelled
    }
    
}
