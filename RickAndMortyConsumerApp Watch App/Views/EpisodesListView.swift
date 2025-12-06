//
//  EpisodesListView.swift
//  RickAndMortyConsumerApp Watch App
//

import SwiftUI

struct EpisodesListView: View {
    @State private var episodes: [RMEpisode] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        Group {
            if isLoading && episodes.isEmpty {
                VStack {
                    ProgressView()
                    Text("Cargando episodios...")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else if let error = errorMessage {
                VStack(spacing: 8) {
                    Text("❌")
                        .font(.largeTitle)
                    Text(error)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                    Button("Reintentar") {
                        fetchEpisodes()
                    }
                    .font(.caption)
                }
                .padding()
            } else {
                List {
                    ForEach(episodes) { episode in
                        EpisodeRow(episode: episode)
                    }
                    
                    // Load more button
                    if !isLoading {
                        Button("Cargar más episodios") {
                            loadMore()
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Episodios")
        .task {
            if episodes.isEmpty {
                fetchEpisodes()
            }
        }
    }
    
    private func fetchEpisodes() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await RMWebService.shared.fetchEpisodes(page: currentPage)
                await MainActor.run {
                    episodes.append(contentsOf: response.results)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error al cargar episodios"
                    isLoading = false
                }
            }
        }
    }
    
    private func loadMore() {
        currentPage += 1
        fetchEpisodes()
    }
}

// MARK: - Episode Row
struct EpisodeRow: View {
    let episode: RMEpisode
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var showMessage = false
    @State private var message = ""
    
    var isFavorite: Bool {
        favoritesManager.isEpisodeFavorite(episode.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    // Episode number
                    Text(episode.episode)
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .bold()
                    
                    // Title
                    Text(episode.name)
                        .font(.caption)
                        .lineLimit(2)
                    
                    // Air date
                    Text(episode.air_date)
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Favorite button
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            
            // Message
            if showMessage {
                Text(message)
                    .font(.system(size: 8))
                    .foregroundColor(.green)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleEpisodeFavorite(episode.id)
        
        if isFavorite {
            message = favoritesManager.getFavoriteMessage()
        } else {
            message = favoritesManager.getRemoveFavoriteMessage()
        }
        
        showMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showMessage = false
        }
    }
}

