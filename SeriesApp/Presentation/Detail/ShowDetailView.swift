//
//  ShowDetailView.swift
//  SeriesApp
//
//  Created by Antonio Alvarez on 11/11/2026.
//

import SwiftUI

struct ShowDetailView: View {
    @State private var viewModel: ShowDetailViewModel
    
    init(viewModel: ShowDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        let show = viewModel.show
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: show.imageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .frame(height: 300)
                        .overlay(Image(systemName: "tv").font(.largeTitle).foregroundStyle(.secondary))
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
                    if let rating = show.rating {
                        LabeledContent("Valoración", value: "\(rating.formatted(.number.precision(.fractionLength(1))))")
                    }
                    if !show.genres.isEmpty {
                        LabeledContent("Géneros", value: show.genres.joined(separator: ", "))
                    }
                    if let status = show.status {
                        LabeledContent("Estado", value: status)
                    }
                    if let premiered = show.premiered {
                        LabeledContent("Estreno", value: premiered)
                    }
                    if let network = show.network {
                        LabeledContent("Cadena", value: network)
                    }
                    if let language = show.language {
                        LabeledContent("Idioma", value: language)
                    }
                }
                
                if let summary = show.summary, !summary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sinopsis").font(.headline)
                        Text(summary).foregroundStyle(.secondary)
                    }
                }
                
                if let site = show.officialSite {
                    Link("Web Oficial", destination: site)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error).font(.footnote).foregroundStyle(.red)
                }
            }
            .padding()
        }
        .navigationTitle(show.name)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            if viewModel.isLoading { ProgressView().padding() }
        }
        .task {
            await viewModel.load()
        }
    }
}
