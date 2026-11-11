//
//  ShowMapper.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import Foundation

extension ShowDTO {
    func toDomain() -> Show {
        Show(id: id, name: name, genres: genres ?? [], status: status, premiered: premiered, rating: rating?.average, network: network?.name ?? webChannel?.name, language: language, summary: summary?.strippingHTML(), imageURL: (image?.original ?? image?.medium).flatMap(URL.init(string: )), officialSite: officialSite.flatMap(URL.init(string: )))
    }
}

private extension String {
    func strippingHTML() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&amp;", with: "&")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
