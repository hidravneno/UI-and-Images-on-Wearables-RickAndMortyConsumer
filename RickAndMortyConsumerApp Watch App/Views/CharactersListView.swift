//
//  CharactersListView.swift
//  RickAndMortyConsumerApp Watch App
//

import SwiftUI

struct CharactersListView: View {
    @State private var characters: [RMCharacter] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    // Grid columns
    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6)
    ]
    
    var body: some View {
        Group {
            if isLoading && characters.isEmpty {
                VStack {
                    ProgressView()
                    Text("Cargando personajes...")
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
                        fetchCharacters()
                    }
                    .font(.caption)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(characters) { character in
                            NavigationLink(destination: CharacterDetailView(character: character)) {
                                CharacterCell(character: character)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(4)
                    
                    // Load more button
                    if !isLoading {
                        Button("Cargar más") {
                            loadMore()
                        }
                        .font(.caption)
                        .padding(.vertical, 8)
                    } else {
                        ProgressView()
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Personajes")
        .task {
            if characters.isEmpty {
                fetchCharacters()
            }
        }
    }
    
    private func fetchCharacters() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await RMWebService.shared.fetchCharacters(page: currentPage)
                await MainActor.run {
                    characters.append(contentsOf: response.results)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error al cargar personajes"
                    isLoading = false
                }
            }
        }
    }
    
    private func loadMore() {
        currentPage += 1
        fetchCharacters()
    }
}

// MARK: - Character Cell
struct CharacterCell: View {
    let character: RMCharacter
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topTrailing) {
                // Image
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.secondary.opacity(0.4))
                            ProgressView()
                        }
                        .frame(width: 70, height: 70)
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.secondary.opacity(0.4))
                            Image(systemName: "person.fill")
                                .font(.caption)
                        }
                        .frame(width: 70, height: 70)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Favorite indicator
                if favoritesManager.isCharacterFavorite(character.id) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                        .padding(3)
                        .background(.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(4)
                }
            }
            
            // Name
            Text(character.name)
                .font(.system(size: 9))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 24)
        }
    }
}

