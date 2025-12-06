//
//  EpisodesView.swift
//  RickAndMortyWatch Watch App
//
//  View for browsing episodes
//

import SwiftUI

struct EpisodesView: View {
    @State private var episodes: [Episode] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @State private var hasMorePages = true
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading && episodes.isEmpty {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                } else if let error = errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await loadEpisodes()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(episodes) { episode in
                            NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                                EpisodeRow(episode: episode)
                            }
                        }
                        
                        if hasMorePages {
                            Button(action: {
                                Task {
                                    await loadMoreEpisodes()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    if isLoading {
                                        ProgressView()
                                            .tint(.blue)
                                    } else {
                                        Text("Load More")
                                            .foregroundColor(.blue)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Episodes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if episodes.isEmpty {
                await loadEpisodes()
            }
        }
    }
    
    private func loadEpisodes() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let response = try await APIService.shared.fetchEpisodes(page: currentPage)
            episodes = response.results
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = "Failed to load episodes"
        }
        
        isLoading = false
    }
    
    private func loadMoreEpisodes() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let response = try await APIService.shared.fetchEpisodes(page: currentPage)
            episodes.append(contentsOf: response.results)
            hasMorePages = response.info.next != nil
        } catch {
            currentPage -= 1
        }
        
        isLoading = false
    }
}

struct EpisodeRow: View {
    let episode: Episode
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(episode.episode)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                Text(episode.name)
                    .font(.footnote)
                    .lineLimit(2)
                
                Text(episode.airDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if favoritesManager.isFavorite(episode: episode) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    EpisodesView()
        .environmentObject(FavoritesManager.shared)
}
