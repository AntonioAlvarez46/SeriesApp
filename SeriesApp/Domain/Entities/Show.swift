//
//  Show.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

struct Show: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let genres: [String]
    let status: String?
    let premiered: String?
    let rating: Double?
    let network: String?
    let language: String?
    let summary: String?
    let imageURL: URL?
    let officialSite: URL?
}
