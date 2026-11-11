//
//  TVMazeEndpoint.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

enum TVMazeEndpoint {
    case search(query: String)
    case showDetail(id: Int)
    
    private static let baseURL = "https://api.tvmaze.com"
    
    var url: URL? {
        var components = URLComponents(string: Self.baseURL)
        
        switch self {
        case .search(let query):
            components?.path = "/search/shows"
            components?.queryItems = [URLQueryItem(name: "q", value: query)]
        case .showDetail(let id):
            components?.path = "/shows/\(id)"
        }
        
        return components?.url
    }
    
}
