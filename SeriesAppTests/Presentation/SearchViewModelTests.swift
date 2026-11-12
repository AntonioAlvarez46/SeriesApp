//
//  SearchViewModelTests.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import XCTest
@testable import SeriesApp

@MainActor
final class SearchViewModelTests: XCTestCase {
    private var useCase: MockSearchShowsUseCase!
    
    override func setUp() {
        super.setUp()
        useCase = MockSearchShowsUseCase()
    }
    
    private func makeSUT(debounce: Duration = .zero) -> SearchViewModel {
        SearchViewModel(searchShowsUseCase: useCase, debounce: debounce)
    }
    
    // MARK: - State
    
    func test_initialState_isIdle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_emptyQuery_setsIdle_andDoesNotSearch() async {
        let sut = makeSUT()
        
        sut.onQueryChanged(" ")
        await sut.searchTask?.value
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(useCase.executedQueries.isEmpty)
    }
    
    func test_search_withResult_setsLoaded() async {
        let shows = [Show.fixture(id: 1, name: "Lost")]
        useCase.resultsByQuery["lost"] = .success(shows)
        let sut = makeSUT()
        
        sut.onQueryChanged("lost")
        await sut.searchTask?.value
        
        XCTAssertEqual(sut.state, .loaded(shows))
    }
    
    func test_search_withNoResults_setsEmpty() async {
        useCase.resultsByQuery["zzz"] = .success([])
        let sut = makeSUT()
        
        sut.onQueryChanged("zzz")
        await sut.searchTask?.value
        
        XCTAssertEqual(sut.state, .empty)
    }
    
    func test_search_withError_setsError() async {
        useCase.resultsByQuery["lost"] = .failure(MockError.generic)
        let sut = makeSUT()
        
        sut.onQueryChanged("lost")
        await sut.searchTask?.value
        
        guard case .error = sut.state else {
            return XCTFail("Expected error state, got \(sut.state)")
        }
    }
    
    // MARK: - Cancellation
    
    func test_newSearch_cancelsPrevious_andIgnoresStaleResults() async {
        let staleShows = [Show.fixture(id: 1, name: "Lo")]
        let freshshows = [Show.fixture(id: 2, name: "Lost")]
        useCase.resultsByQuery = ["lo": .success(staleShows), "lost": .success(freshshows)]
        useCase.delayByQuery = ["lo": .milliseconds(300)]
        let sut = makeSUT()
        
        sut.onQueryChanged("lo")
        let firstTask = sut.searchTask
        while useCase.executedQueries.isEmpty { await Task.yield() }
        
        sut.onQueryChanged("lost")
        
        await firstTask?.value
        await sut.searchTask?.value
        
        XCTAssertEqual(sut.state, .loaded(freshshows))
        XCTAssertEqual(useCase.executedQueries, ["lo", "lost"])
    }
    
    func test_fastTyping_onlyLastQueryReachesUseCase() async {
        let sut = makeSUT(debounce: .milliseconds(100))
        
        sut.onQueryChanged("l")
        sut.onQueryChanged("lo")
        sut.onQueryChanged("los")
        sut.onQueryChanged("lost")
        await sut.searchTask?.value
        
        XCTAssertEqual(useCase.executedQueries, ["lost"])
    }
    
    func test_clearingQuery_cancelsSearch_andReturnsToIdle() async {
        useCase.resultsByQuery["lost"] = .success([Show.fixture()])
        let sut = makeSUT(debounce: .milliseconds(100))
        
        sut.onQueryChanged("lost")
        let task = sut.searchTask
        sut.onQueryChanged("")
        await task?.value
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(useCase.executedQueries.isEmpty)
    }
    
}
