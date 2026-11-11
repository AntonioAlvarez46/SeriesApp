//
//  SearchShowsUseCaseTests.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import XCTest
@testable import SeriesApp

@MainActor
final class SearchShowsUseCaseTests: XCTestCase {
    
    func test_execute_returnsShowsFromRepository() async throws {
        let repository = MockShowsRepository()
        let expected = [Show.fixture(id: 1), Show.fixture(id: 2, name: "Lost")]
        repository.searchResult = .success(expected)
        let sut = DefaultSearchShowsUseCase(repository: repository)
        
        let result = try await sut.execute(query: "bad")
        
        XCTAssertEqual(result, expected)
    }
    
    func test_execute_trimsQueryBeforeCallingRepository() async throws {
        let repository = MockShowsRepository()
        let sut = DefaultSearchShowsUseCase(repository: repository)
        
        _ = try await sut.execute(query: " lost ")
        
        XCTAssertEqual(repository.receivedQueries, ["lost"])
    }
    
    func test_execute_withEmptyQuery_doesNotCallRepository() async throws {
        let repository = MockShowsRepository()
        let sut = DefaultSearchShowsUseCase(repository: repository)
        
        let result = try await sut.execute(query: " ")
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertEqual(repository.searchCallCount, 0)
    }
    
    func test_execute_propagatesRepositoryError() async {
        let repository = MockShowsRepository()
        repository.searchResult = .failure(MockError.generic)
        let sut = DefaultSearchShowsUseCase(repository: repository)
        
        do {
            _ = try await sut.execute(query: "bad")
            XCTFail("Expected Error")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }
    
}
