//
//  MockShowsRepository.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

@testable import SeriesApp

final class MockShowsRepository: ShowsRepository, @unchecked Sendable {
    var searchResult: Result<[Show], Error> = .success([])
    var detailResult: Result<Show, Error> = .failure(MockError.notConfigured)
    
    private(set) var searchCallCount = 0
    private(set) var receivedQueries: [String] = []
    
    func searchShows(query: String) async throws -> [Show] {
        searchCallCount += 1
        receivedQueries.append(query)
        return try searchResult.get()
    }
    
    func getShowDetail(id: Int) async throws -> Show {
        try detailResult.get()
    }
    
}

enum MockError: Error {
    case notConfigured
    case generic
}

extension Show {
    static func fixture(id: Int = 1, name: String = "Breaking Bad") -> Show {
        Show(id: id, name: name, genres: ["Drama"], status: "Ended", premiered: "2008-01-20", rating: 9.2, network: "AMC", language: "English", summary: "A chemistry teacher...", imageURL: nil, officialSite: nil)
    }
}
