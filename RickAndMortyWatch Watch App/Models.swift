//
//  Models.swift
//  RickAndMortyWatch Watch App
//
//  Data models for Rick and Morty API
//

import Foundation

// MARK: - Character
struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable, Hashable {
    let name: String
    let url: String
}

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Episode
struct Episode: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Episode]
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Favorite
struct Favorite: Codable, Identifiable {
    let id: String
    let type: FavoriteType
    let characterId: Int?
    let episodeId: Int?
    let timestamp: Date
    
    init(character: Character) {
        self.id = "character_\(character.id)"
        self.type = .character
        self.characterId = character.id
        self.episodeId = nil
        self.timestamp = Date()
    }
    
    init(episode: Episode) {
        self.id = "episode_\(episode.id)"
        self.type = .episode
        self.characterId = nil
        self.episodeId = episode.id
        self.timestamp = Date()
    }
}

enum FavoriteType: String, Codable {
    case character
    case episode
}
