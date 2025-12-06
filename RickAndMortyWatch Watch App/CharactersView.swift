//
//  CharactersView.swift
//  RickAndMortyWatch Watch App
//
//  View for browsing characters
//

import SwiftUI

struct CharactersView: View {
    @State private var characters: [Character] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @State private var hasMorePages = true
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading && characters.isEmpty {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(.green)
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
                                await loadCharacters()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(characters) { character in
                            NavigationLink(destination: CharacterDetailView(character: character)) {
                                CharacterRow(character: character)
                            }
                        }
                        
                        if hasMorePages {
                            Button(action: {
                                Task {
                                    await loadMoreCharacters()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    if isLoading {
                                        ProgressView()
                                            .tint(.green)
                                    } else {
                                        Text("Load More")
                                            .foregroundColor(.green)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Characters")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if characters.isEmpty {
                await loadCharacters()
            }
        }
    }
    
    private func loadCharacters() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let response = try await APIService.shared.fetchCharacters(page: currentPage)
            characters = response.results
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = "Failed to load characters"
        }
        
        isLoading = false
    }
    
    private func loadMoreCharacters() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let response = try await APIService.shared.fetchCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
            hasMorePages = response.info.next != nil
        } catch {
            currentPage -= 1
        }
        
        isLoading = false
    }
}

struct CharacterRow: View {
    let character: Character
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        HStack(spacing: 8) {
            CachedAsyncImage(url: character.image)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(statusColor, lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(character.species)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if favoritesManager.isFavorite(character: character) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
    }
    
    private var statusColor: Color {
        switch character.status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    CharactersView()
        .environmentObject(FavoritesManager.shared)
}
