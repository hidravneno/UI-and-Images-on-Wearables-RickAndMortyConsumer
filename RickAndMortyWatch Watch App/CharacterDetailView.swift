//
//  CharacterDetailView.swift
//  RickAndMortyWatch Watch App
//
//  Detail view for a character
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showFavoriteAnimation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Character Image
                ZStack {
                    CachedAsyncImage(url: character.image)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(statusColor, lineWidth: 3))
                        .shadow(color: statusColor.opacity(0.5), radius: 10)
                    
                    if showFavoriteAnimation {
                        Image(systemName: "star.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showFavoriteAnimation)
                
                // Name
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Status Badge
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(character.status)
                        .font(.caption)
                        .foregroundColor(statusColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .cornerRadius(12)
                
                Divider()
                    .padding(.vertical, 4)
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Species", value: character.species)
                    InfoRow(label: "Gender", value: character.gender)
                    InfoRow(label: "Origin", value: character.origin.name)
                    InfoRow(label: "Location", value: character.location.name)
                    
                    if !character.type.isEmpty {
                        InfoRow(label: "Type", value: character.type)
                    }
                }
                
                // Favorite Button
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                        Text(isFavorite ? "Remove Favorite" : "Add Favorite")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(isFavorite ? .yellow : .green)
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isFavorite: Bool {
        favoritesManager.isFavorite(character: character)
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
        favoritesManager.toggleFavorite(character: character)
        
        // Show animation
        showFavoriteAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showFavoriteAnimation = false
        }
        
        // Haptic feedback
        WKInterfaceDevice.current().play(.notification)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.caption)
                .lineLimit(2)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        CharacterDetailView(character: Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Location(name: "Earth (C-137)", url: ""),
            location: Location(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""
        ))
        .environmentObject(FavoritesManager.shared)
    }
}
