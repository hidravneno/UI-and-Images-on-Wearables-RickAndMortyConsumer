//
//  CharacterDetailView.swift
//  RickAndMortyConsumerApp
//
//  Created by francisco eduardo aramburo reyes on 05/12/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var showMessage = false
    @State private var message = ""
    
    var isFavorite: Bool {
        favoritesManager.isCharacterFavorite(character.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Image
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.secondary.opacity(0.4))
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.secondary.opacity(0.4))
                            Image(systemName: "person.fill")
                        }
                        .frame(width: 120, height: 120)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Name
                Text(character.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                // Status Badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)
                    Text(character.status)
                        .font(.caption2)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.secondary.opacity(0.2))
                .clipShape(Capsule())
                
                Divider()
                    .padding(.vertical, 4)
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    InfoRow(label: "Species", value: character.species)
                    InfoRow(label: "Gender", value: character.gender)
                    InfoRow(label: "Origin", value: character.origin.name)
                    InfoRow(label: "Location", value: character.location.name)
                    InfoRow(label: "Episodes", value: "\(character.episode.count)")
                }
                .padding(.horizontal, 4)
                
                // Favorite Button
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                        Text(isFavorite ? "Remove from favorites" : "Add to favorites")
                            .font(.caption)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(isFavorite ? .yellow : .blue)
                .padding(.top, 8)
                
                // Message
                if showMessage {
                    Text(message)
                        .font(.caption2)
                        .foregroundColor(.green)
                        .padding(.top, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
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
    
    private func toggleFavorite() {
        favoritesManager.toggleCharacterFavorite(character.id)
        
        if isFavorite {
            message = favoritesManager.getFavoriteMessage()
        } else {
            message = favoritesManager.getRemoveFavoriteMessage()
        }
        
        showMessage = true
        
        // Hide message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showMessage = false
        }
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .lineLimit(2)
        }
    }
}
