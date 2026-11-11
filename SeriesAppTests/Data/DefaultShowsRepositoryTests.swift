//
//  DefaultShowsRepositoryTests.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import XCTest
@testable import SeriesApp

@MainActor
final class DefaultShowsRepositoryTests: XCTestCase {
    
    private var httpClient: MockHTTPClient!
    private var clock: MockClock!
    private var sut: DefaultShowsRepository!
    
    override func setUp() {
        super.setUp()
        httpClient = MockHTTPClient()
        httpClient.result = .success(Self.searchJSON)
        clock = MockClock()
        let clock = self.clock!
        let cache = SearchCache(ttl: 300, now: { clock.currentDate })
        sut = DefaultShowsRepository(httpClient: httpClient, cache: cache)
    }
    
    // MARK: - Cache
    
    func test_search_firstTime_callsNetwork() async throws {
        _ = try await sut.searchShows(query: "bad")
        
        XCTAssertEqual(httpClient.callCount, 1)
    }
    
    func test_search_sameQueryWithinTTL_usesCacheWithoutNetwork() async throws {
        _ = try await sut.searchShows(query: "bad")
        clock.advance(by: 299)
        
        let result = try await sut.searchShows(query: "bad")
        
        XCTAssertEqual(httpClient.callCount, 1)
        XCTAssertEqual(result.first?.name, "Breaking Bad")
    }
    
    func test_search_afterTTLExpires_callsNetworkAgain() async throws {
        _ = try await sut.searchShows(query: "bad")
        clock.advance(by: 301)
        
        _ = try await sut.searchShows(query: "bad")
        
        XCTAssertEqual(httpClient.callCount, 2)
    }
    
    func test_search_differentQueries_areCachedSeparately() async throws {
        _ = try await sut.searchShows(query: "bad")
        _ = try await sut.searchShows(query: "lost")
        
        XCTAssertEqual(httpClient.callCount, 2)
    }
    
    func test_search_queryIsNormalized_forCacheKey() async throws {
        _ = try await sut.searchShows(query: "Lost")
        _ = try await sut.searchShows(query: " lost ")
        
        XCTAssertEqual(httpClient.callCount, 1)
    }
    
    func test_search_errorsAreNotCache() async throws {
        httpClient.result = .failure(NetworkError.statusCode(500))
        _ = try? await sut.searchShows(query: "bad")
        
        httpClient.result = .success(Self.searchJSON)
        _ = try await sut.searchShows(query: "bad")
        
        XCTAssertEqual(httpClient.callCount, 2)
    }
    
    // MARK: - Mapping
    
    func test_search_mapsDTOToDomain_andStripsHTML() async throws {
        let result = try await sut.searchShows(query: "bad")
        
        let show = try XCTUnwrap(result.first)
        
        XCTAssertEqual(show.id, 169)
        XCTAssertEqual(show.network, "AMC")
        XCTAssertEqual(show.rating, 9.2)
        XCTAssertEqual(show.summary, "A teacher turns to crime.")
    }
    
    // MARK: - Fixtures
    
    private static let searchJSON = Data(
        """
        [
            {
                "score": 0.9,
                "show": {
                            "id": 169,
                            "name": "Breaking Bad",
                            "genres": ["Drama", "Crime"],
                            "status": "Ended",
                            "premiered": "2008-01-20",
                            "rating": { "average": 9.2 },            
                            "network": { "name": "AMC" },
                            "webChannel": null,
                            "language": "English",
                            "summary": "<p>A <b>teacher</b> turns to crime.</p>",
                            "image": { "medium": "https://example.com/m.jpg", "original": "https://example.com/o.jpg" },
                            "officialSite": null,
                        }
            }
        ]
        """.utf8
    )
    
}
