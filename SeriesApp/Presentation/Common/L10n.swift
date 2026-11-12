//
//  L10n.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 12/11/2026.
//

import Foundation

enum L10n {
    
    enum Common {
        static var errorTitle: String { String(localized: "common.error.title") }
        static var retry: String { String(localized: "common.retry") }
    }
    
    enum Search {
        static var title: String { String(localized: "search.title") }
        static var prompt: String { String(localized: "search.prompt") }
        static var loading: String { String(localized: "search.loading") }
        static var idleTitle: String { String(localized: "search.idle.title") }
        static var idleDescription: String { String(localized: "search.idle.description") }
        static var emptyTitle: String { String(localized: "search.empty.title") }
        static var errorMessage: String { String(localized: "search.error.message") }
        
        static func emptyDescription(_ query: String) -> String {
            String(format: String(localized: "search.empty.description"), query)
        }
    }
    
    enum Detail {
        static var rating: String { String(localized: "detail.rating") }
        static var genres: String { String(localized: "detail.genres") }
        static var status: String { String(localized: "detail.status") }
        static var premiered: String { String(localized: "detail.premiered") }
        static var network: String { String(localized: "detail.network") }
        static var language: String { String(localized: "detail.language") }
        static var synopsis: String { String(localized: "detail.synopsis") }
        static var officialSite: String { String(localized: "detail.officialSite") }
        static var errorMessage: String { String(localized: "detail.error.message") }
    }
}
