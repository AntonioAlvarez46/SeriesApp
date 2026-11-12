//
//  SearchCache.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

actor SearchCache {
    // MARK: - Types
    private struct Entry {
        let shows: [Show]
        let expirationDate: Date
    }
    
    // MARK: - Properties
    private var storage: [String: Entry] = [:]
    private let ttl: TimeInterval
    private let now: @Sendable () -> Date
    
    // MARK: - Init
    init(ttl: TimeInterval = 300, now: @escaping @Sendable () -> Date = { Date() }) {
        self.ttl = ttl
        self.now = now
    }
    
    // MARK: - Public API
    func shows(for query: String) -> [Show]? {
        let key = Self.key(for: query)
        guard let entry = storage[key] else { return nil }
        
        guard now() < entry.expirationDate  else {
            storage[key] = nil
            return nil
        }
        
        return entry.shows
    }
    
    func save(_ shows: [Show], for query: String) {
        storage[Self.key(for: query)] = Entry(
            shows: shows, expirationDate: now().addingTimeInterval(ttl)
        )
    }
    
    // MARK: - Private
    private static func key(for query: String) -> String {
        query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
}
