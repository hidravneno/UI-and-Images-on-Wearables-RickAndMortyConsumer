//
//  FavoritesView.swift
//  RickAndMortyWatch Watch App
//
//  View for displaying favorites
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var characters: [Character] = []
    @State private var episodes: [Episode] = []
    @State private var isLoading = false
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if favoritesManager.favorites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        
                        Text("No Favorites")
                            .font(.headline)
                        
                        Text("Add characters or episodes to your favorites")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        // Favorite Characters Section
                        if !characters.isEmpty {
                            Section(header: Text("Characters").foregroundColor(.green)) {
                                ForEach(characters) { character in
                                    NavigationLink(destination: CharacterDetailView(character: character)) {
                                        CharacterRow(character: character)
                                    }
                                }
                            }
                        }
                        
                        // Favorite Episodes Section
                        if !episodes.isEmpty {
                            Section(header: Text("Episodes").foregroundColor(.blue)) {
                                ForEach(episodes) { episode in
                                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                                        EpisodeRow(episode: episode)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadFavorites()
        }
        .onChange(of: favoritesManager.favorites) { _, _ in
            Task {
                await loadFavorites()
            }
        }
    }
    
    private func loadFavorites() async {
        isLoading = true
        
        var loadedCharacters: [Character] = []
        var loadedEpisodes: [Episode] = []
        
        // Load favorite characters
        for id in favoritesManager.getFavoriteCharacterIds() {
            if let character = try? await APIService.shared.fetchCharacter(id: id) {
                loadedCharacters.append(character)
            }
        }
        
        // Load favorite episodes
        for id in favoritesManager.getFavoriteEpisodeIds() {
            if let episode = try? await APIService.shared.fetchEpisode(id: id) {
                loadedEpisodes.append(episode)
            }
        }
        
        characters = loadedCharacters
        episodes = loadedEpisodes
        
        isLoading = false
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager.shared)
}
