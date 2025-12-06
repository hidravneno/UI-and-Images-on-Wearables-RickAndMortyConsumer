//
//  RMCharacter.swift
//  RickAndMortyConsumerApp Watch App
//

import Foundation

// MARK: - API Response
struct RMCharactersResponse: Codable {
    let info: RMInfoResponse
    let results: [RMCharacter]
}

struct RMInfoResponse: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Character Model
struct RMCharacter: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let status: String // "Alive", "Dead", "unknown"
    let species: String
    let type: String
    let gender: String
    let origin: RMLocation
    let location: RMLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    // Computed property to check if the character is alive
    var isAlive: Bool {
        status.lowercased() == "alive"
    }
    
    // Color based on character status
    var statusColor: String {
        switch status.lowercased() {
        case "alive":
            return "green"
        case "dead":
            return "red"
        default:
            return "gray"
        }
    }
}

// MARK: - Location
struct RMLocation: Codable, Hashable {
    let name: String
    let url: String
}
