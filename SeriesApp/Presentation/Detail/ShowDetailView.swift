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
                        LabeledContent(L10n.Detail.rating, value: "\(rating.formatted(.number.precision(.fractionLength(1))))")
                    }
                    if !show.genres.isEmpty {
                        LabeledContent(L10n.Detail.genres, value: show.genres.joined(separator: ", "))
                    }
                    if let status = show.status {
                        LabeledContent(L10n.Detail.status, value: status)
                    }
                    if let premiered = show.premiered {
                        LabeledContent(L10n.Detail.premiered, value: premiered)
                    }
                    if let network = show.network {
                        LabeledContent(L10n.Detail.network, value: network)
                    }
                    if let language = show.language {
                        LabeledContent(L10n.Detail.language, value: language)
                    }
                }
                
                if let summary = show.summary, !summary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.Detail.synopsis).font(.headline)
                        Text(summary).foregroundStyle(.secondary)
                    }
                }
                
                if let site = show.officialSite {
                    Link(L10n.Detail.officialSite, destination: site)
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
