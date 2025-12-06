//
//  FavoritesManager.swift
//  RickAndMortyConsumerApp Watch App
//

import Foundation
import Combine

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteCharacterIds: Set<Int> = []
    @Published var favoriteEpisodeIds: Set<Int> = []
    
    private let charactersKey = "favoriteCharacters"
    private let episodesKey = "favoriteEpisodes"
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - Characters
    func toggleCharacterFavorite(_ characterId: Int) {
        if favoriteCharacterIds.contains(characterId) {
            favoriteCharacterIds.remove(characterId)
        } else {
            favoriteCharacterIds.insert(characterId)
        }
        saveFavorites()
    }
    
    func isCharacterFavorite(_ characterId: Int) -> Bool {
        favoriteCharacterIds.contains(characterId)
    }
    
    // MARK: - Episodes
    func toggleEpisodeFavorite(_ episodeId: Int) {
        if favoriteEpisodeIds.contains(episodeId) {
            favoriteEpisodeIds.remove(episodeId)
        } else {
            favoriteEpisodeIds.insert(episodeId)
        }
        saveFavorites()
    }
    
    func isEpisodeFavorite(_ episodeId: Int) -> Bool {
        favoriteEpisodeIds.contains(episodeId)
    }
    
    // MARK: - Persistence
    private func saveFavorites() {
        let charArray = Array(favoriteCharacterIds)
        let epArray = Array(favoriteEpisodeIds)
        
        UserDefaults.standard.set(charArray, forKey: charactersKey)
        UserDefaults.standard.set(epArray, forKey: episodesKey)
        
        print("💾 Saved favorites: \(charArray.count) characters, \(epArray.count) episodes")
    }
    
    private func loadFavorites() {
        if let charArray = UserDefaults.standard.array(forKey: charactersKey) as? [Int] {
            favoriteCharacterIds = Set(charArray)
        }
        
        if let epArray = UserDefaults.standard.array(forKey: episodesKey) as? [Int] {
            favoriteEpisodeIds = Set(epArray)
        }
        
        print("📂 Loaded favorites: \(favoriteCharacterIds.count) characters, \(favoriteEpisodeIds.count) episodes")
    }
    
    // MARK: - Clear all
    func clearAllFavorites() {
        favoriteCharacterIds.removeAll()
        favoriteEpisodeIds.removeAll()
        saveFavorites()
    }
    
    // MARK: - Rick & Morty Messages
    func getFavoriteMessage() -> String {
        let messages = [
            "Wubba Lubba Dub Dub! 💚",
            "Saved to favorites, Morty!",
            "Get schwifty! ⭐",
            "Aw jeez, another favorite!",
            "Fantastic! -Rick",
            "I like what you've got! 👍"
        ]
        return messages.randomElement() ?? "Favorite saved!"
    }
    
    func getRemoveFavoriteMessage() -> String {
        let messages = [
            "Burp* Goodbye favorite",
            "Not your favorite anymore, Morty!",
            "Deleted from the portal 🌀",
            "Aw man, okay!",
            "Erased from dimension C-137"
        ]
        return messages.randomElement() ?? "Removed from favorites"
    }
}
