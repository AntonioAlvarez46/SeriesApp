//
//  GetShowDetailUseCase.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

protocol GetShowDetailUseCase: Sendable {
    func execute(id: Int) async throws -> Show
}

struct DefaultGetShowDetailUseCase: GetShowDetailUseCase {
    private let repository: ShowsRepository
    
    init(repository: ShowsRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> Show {
        try await repository.getShowDetail(id: id)
    }
    
}
