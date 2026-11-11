//
//  DefaultShowsRepository.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

struct DefaultShowsRepository: ShowsRepository {
    private let httpClient: HTTPClient
    private let cache: SearchCache
    
    init(httpClient: HTTPClient, cache: SearchCache) {
        self.httpClient = httpClient
        self.cache = cache
    }
    
    func searchShows(query: String) async throws -> [Show] {
        if let cached = await cache.shows(for: query) {
            return cached
        }
        
        guard let url = TVMazeEndpoint.search(query: query).url else {
            throw NetworkError.invalidUrl
        }
        let data = try await  httpClient.get(url)
        let results = try decode([SearchResultDTO].self, from: data)
        let shows = results.map { $0.show.toDomain() }
        
        await cache.save(shows, for: query)
        
        return shows
        
    }
    
    func getShowDetail(id: Int) async throws -> Show {
        guard let url = TVMazeEndpoint.showDetail(id: id).url else {
            throw NetworkError.invalidUrl
        }
        let data = try await httpClient.get(url)
        
        return try decode(ShowDTO.self, from: data).toDomain()
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
    
}
