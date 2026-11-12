//
//  MockSearchShowsUseCase.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 12/11/2026.
//

@testable import SeriesApp

final class MockSearchShowsUseCase: SearchShowsUseCase, @unchecked Sendable {
    var resultsByQuery: [String: Result<[Show], Error>] = [:]
    var delayByQuery: [String: Duration] = [:]
    private(set) var executedQueries: [String] = []
    
    func execute(query: String) async throws -> [Show] {
        executedQueries.append(query)
        
        if let delay = delayByQuery[query] {
            try? await Task.sleep(for: delay)
        }
        return try (resultsByQuery[query] ?? .success([])).get()
    }
    
}
