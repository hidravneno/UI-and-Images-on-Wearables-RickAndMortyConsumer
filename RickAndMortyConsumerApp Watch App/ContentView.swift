//
//  ContentView.swift
//  RickAndMortyConsumerApp Watch App
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                // Header
                Section {
                    VStack(spacing: 4) {
                        Text("🛸")
                            .font(.system(size: 40))
                        Text("Rick & Morty")
                            .font(.headline)
                        Text("Get Schwifty!")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                
                // Navigation Options
                Section {
                    NavigationLink(destination: CharactersListView()) {
                        Label {
                            Text("Characters")
                        } icon: {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    NavigationLink(destination: EpisodesListView()) {
                        Label {
                            Text("Episodes")
                        } icon: {
                            Image(systemName: "tv.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    NavigationLink(destination: FavoritesView()) {
                        Label {
                            HStack {
                                Text("Favorites")
                                if favoritesManager.favoriteCharacterIds.count + favoritesManager.favoriteEpisodeIds.count > 0 {
                                    Text("(\(favoritesManager.favoriteCharacterIds.count + favoritesManager.favoriteEpisodeIds.count))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                // Info Section
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("API: rickandmortyapi.com")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Text("watchOS App")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Rick & Morty")
        }
    }
}

#Preview {
    ContentView()
}
