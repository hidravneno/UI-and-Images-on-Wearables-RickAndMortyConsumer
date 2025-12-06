//
//  FavoritesView.swift
//  RickAndMortyConsumerApp Watch App
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var favoriteCharacters: [RMCharacter] = []
    @State private var isLoadingCharacters = false
    
    var body: some View {
        Group {
            if favoritesManager.favoriteCharacterIds.isEmpty && favoritesManager.favoriteEpisodeIds.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "star.slash")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No favorites")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Add characters or episodes to favorites")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                List {
                    // Characters Section
                    if !favoritesManager.favoriteCharacterIds.isEmpty {
                        Section {
                            if isLoadingCharacters {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            } else if favoriteCharacters.isEmpty {
                                Text("Loading...")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(favoriteCharacters) { character in
                                    NavigationLink(destination: CharacterDetailView(character: character)) {
                                        FavoriteCharacterRow(character: character)
                                    }
                                }
                            }
                        } header: {
                            Text("Characters (\(favoritesManager.favoriteCharacterIds.count))")
                        }
                    }
                    
                    // Episodes Section
                    if !favoritesManager.favoriteEpisodeIds.isEmpty {
                        Section {
                            Text("Favorite episodes: \(favoritesManager.favoriteEpisodeIds.count)")
                                .font(.caption)
                        } header: {
                            Text("Episodes")
                        }
                    }
                    
                    // Clear button
                    if !favoritesManager.favoriteCharacterIds.isEmpty || !favoritesManager.favoriteEpisodeIds.isEmpty {
                        Section {
                            Button(role: .destructive) {
                                favoritesManager.clearAllFavorites()
                                favoriteCharacters.removeAll()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Clear favorites")
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .task {
            await loadFavoriteCharacters()
        }
        .onChange(of: favoritesManager.favoriteCharacterIds) { _, _ in
            Task {
                await loadFavoriteCharacters()
            }
        }
    }
    
    private func loadFavoriteCharacters() async {
        guard !favoritesManager.favoriteCharacterIds.isEmpty else {
            favoriteCharacters.removeAll()
            return
        }
        
        isLoadingCharacters = true
        var loadedCharacters: [RMCharacter] = []
        
        for id in favoritesManager.favoriteCharacterIds {
            do {
                let character = try await RMWebService.shared.fetchCharacter(id: id)
                loadedCharacters.append(character)
            } catch {
                print("Error loading character \(id): \(error)")
            }
        }
        
        await MainActor.run {
            favoriteCharacters = loadedCharacters
            isLoadingCharacters = false
        }
    }
}

// MARK: - Favorite Character Row
struct FavoriteCharacterRow: View {
    let character: RMCharacter
    
    var body: some View {
        HStack(spacing: 8) {
            // Image
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.secondary.opacity(0.4))
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.secondary.opacity(0.4))
                        Image(systemName: "person.fill")
                            .font(.caption2)
                    }
                    .frame(width: 40, height: 40)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.caption)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor(for: character.status))
                        .frame(width: 4, height: 4)
                    Text(character.status)
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
    }
}
