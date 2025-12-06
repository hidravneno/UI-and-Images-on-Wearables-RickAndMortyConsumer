//
//  FavoritesManager.swift
//  RickAndMortyWatch Watch App
//
//  Local storage for favorites
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published private(set) var favorites: [Favorite] = []
    
    private let favoritesKey = "savedFavorites"
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - Load/Save
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            favorites = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
            favorites = []
        }
    }
    
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    // MARK: - Character Favorites
    func isFavorite(character: Character) -> Bool {
        favorites.contains { $0.characterId == character.id && $0.type == .character }
    }
    
    func toggleFavorite(character: Character) {
        if let index = favorites.firstIndex(where: { $0.characterId == character.id && $0.type == .character }) {
            favorites.remove(at: index)
        } else {
            favorites.append(Favorite(character: character))
        }
        saveFavorites()
    }
    
    // MARK: - Episode Favorites
    func isFavorite(episode: Episode) -> Bool {
        favorites.contains { $0.episodeId == episode.id && $0.type == .episode }
    }
    
    func toggleFavorite(episode: Episode) {
        if let index = favorites.firstIndex(where: { $0.episodeId == episode.id && $0.type == .episode }) {
            favorites.remove(at: index)
        } else {
            favorites.append(Favorite(episode: episode))
        }
        saveFavorites()
    }
    
    // MARK: - Get Favorites
    func getFavoriteCharacterIds() -> [Int] {
        favorites.filter { $0.type == .character }
            .compactMap { $0.characterId }
    }
    
    func getFavoriteEpisodeIds() -> [Int] {
        favorites.filter { $0.type == .episode }
            .compactMap { $0.episodeId }
    }
    
    func clearAllFavorites() {
        favorites.removeAll()
        saveFavorites()
    }
}
