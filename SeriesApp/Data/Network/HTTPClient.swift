//
//  HTTPClient.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

protocol HTTPClient: Sendable {
    func get(_ url: URL) async throws -> Data
}
