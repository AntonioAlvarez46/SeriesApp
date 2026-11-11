//
//  SearchShowsUseCase.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

protocol SearchShowsUseCase: Sendable {
    func execute(query: String) async throws -> [Show]
}

struct DefaultSearchShowsUseCase: SearchShowsUseCase {
    private let repository: ShowsRepository
    
    init(repository: ShowsRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [Show] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }
        
        return try await repository.searchShows(query: trimmedQuery)
    }
    
}
