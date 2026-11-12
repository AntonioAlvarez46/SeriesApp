//
//  ShowDetailViewModel.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ShowDetailViewModel {
    private(set) var show: Show
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let getShowDetailUseCase: GetShowDetailUseCase
    
    init(show: Show, getShowDetailUseCase: GetShowDetailUseCase) {
        self.show = show
        self.getShowDetailUseCase = getShowDetailUseCase
    }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            show = try await getShowDetailUseCase.execute(id: show.id)
            errorMessage = nil
        } catch is CancellationError {
            // User left the screen
        } catch {
            errorMessage = "No se pudo actualizar el detalle"
        }
    }
    
}
