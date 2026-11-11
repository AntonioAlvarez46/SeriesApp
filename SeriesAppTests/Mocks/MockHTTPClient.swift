//
//  MockHTTPClient.swift
//  SeriesAppTests
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation
@testable import SeriesApp

final class MockHTTPClient: HTTPClient, @unchecked Sendable {
    var result: Result<Data, Error> = .success(Data())
    private(set) var requestedURLs: [URL] = []
    
    var callCount: Int { requestedURLs.count }
    
    func get(_ url: URL) async throws -> Data {
        requestedURLs.append(url)
        return try result.get()
    }
    
}
