//
//  EpisodeDetailView.swift
//  RickAndMortyWatch Watch App
//
//  Detail view for an episode
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showFavoriteAnimation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Episode Badge
                VStack(spacing: 4) {
                    Text(episode.episode)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    ZStack {
                        if showFavoriteAnimation {
                            Image(systemName: "star.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .frame(height: showFavoriteAnimation ? 50 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showFavoriteAnimation)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(15)
                
                // Episode Name
                Text(episode.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Air Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(episode.airDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(12)
                
                Divider()
                    .padding(.vertical, 4)
                
                // Character Count
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundColor(.green)
                        Text("Characters")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    Text("\(episode.characters.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)
                
                // Favorite Button
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                        Text(isFavorite ? "Remove Favorite" : "Add Favorite")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(isFavorite ? .yellow : .blue)
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isFavorite: Bool {
        favoritesManager.isFavorite(episode: episode)
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleFavorite(episode: episode)
        
        // Show animation
        showFavoriteAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showFavoriteAnimation = false
        }
        
        // Haptic feedback
        WKInterfaceDevice.current().play(.notification)
    }
}

#Preview {
    NavigationView {
        EpisodeDetailView(episode: Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01",
            characters: [],
            url: "",
            created: ""
        ))
        .environmentObject(FavoritesManager.shared)
    }
}
