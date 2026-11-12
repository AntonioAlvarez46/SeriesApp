//
//  ShowDTO.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

struct ShowDTO: Decodable {
    let id: Int
    let name: String
    let genres: [String]?
    let status: String?
    let premiered: String?
    let rating: RatingDTO?
    let network: NetworkDTO?
    let webChannel: NetworkDTO?
    let language: String?
    let summary: String?
    let image: ImageDTO?
    let officialSite: String?
    
    struct RatingDTO: Decodable {
        let average: Double?
    }
    
    struct NetworkDTO: Decodable {
        let name: String
    }
    
    struct ImageDTO: Decodable {
        let medium: String?
        let original: String?
    }
    
}
