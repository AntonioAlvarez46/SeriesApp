//
//  NetworkError.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

enum NetworkError: Error, Equatable {
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
    case decoding
}
