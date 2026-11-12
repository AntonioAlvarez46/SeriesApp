//
//  AppContainer.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

@MainActor
final class AppContainer {
    private let repository: ShowsRepository
    
    init() {
        repository = DefaultShowsRepository(httpClient: URLSessionHTTPClient(), cache: SearchCache(ttl: 300))
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchShowsUseCase: DefaultSearchShowsUseCase(repository: repository))
    }
    
    func makeShowDetailViewModel(show: Show) -> ShowDetailViewModel {
        ShowDetailViewModel(show: show, getShowDetailUseCase: DefaultGetShowDetailUseCase(repository: repository))
    }
    
}
