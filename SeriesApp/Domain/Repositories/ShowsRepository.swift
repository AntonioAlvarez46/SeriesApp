//
//  ShowsRepository.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

protocol ShowsRepository: Sendable {
    func searchShows(query: String) async throws -> [Show]
    func getShowDetail(id: Int) async throws -> Show
}
