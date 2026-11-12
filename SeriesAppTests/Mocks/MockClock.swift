//
//  MockClock.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

final class MockClock: @unchecked Sendable {
    var currentDate = Date(timeIntervalSince1970: 0)
    
    func advance(by seconds: TimeInterval) {
        currentDate = currentDate.addingTimeInterval(seconds)
    }
    
}
