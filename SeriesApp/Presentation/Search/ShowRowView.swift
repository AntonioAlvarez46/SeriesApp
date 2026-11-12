//
//  ShowRowView.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import SwiftUI

struct ShowRowView: View {
    let show: Show
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: show.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
                    .overlay(Image(systemName: "tv").foregroundStyle(.secondary))
            }
            .frame(width: 50, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(show.name)
                    .font(.headline)
                if let year = show.premiered?.prefix(4) {
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !show.genres.isEmpty {
                    Text(show.genres.joined(separator: " . "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
