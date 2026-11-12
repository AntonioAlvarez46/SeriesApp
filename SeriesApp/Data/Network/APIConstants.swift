//
//  APIConstants.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 12/11/2026.
//

enum APIConstants {
    
    enum TVMaze {
        static let baseURL = "https://api.tvmaze.com"
        
        enum Path {
            static let searchShows = "/search/shows"
            
            static func showDetail(id: Int) -> String {
                "/shows/\(id)"
            }
        }
        
        enum QueryParameter {
            static let query = "q"
        }
        
    }
}
