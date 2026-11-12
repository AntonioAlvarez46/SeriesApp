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
    
    var url: URL? {
        var components = URLComponents(string: APIConstants.TVMaze.baseURL)
        
        switch self {
        case .search(let query):
            components?.path = APIConstants.TVMaze.Path.searchShows
            components?.queryItems = [URLQueryItem(name: APIConstants.TVMaze.QueryParameter.query, value: query)]
        case .showDetail(let id):
            components?.path = APIConstants.TVMaze.Path.showDetail(id: id)
        }
        
        return components?.url
    }
    
}
