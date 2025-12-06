//
//  RMEpisode.swift
//  RickAndMortyConsumerApp Watch App
//

import Foundation

// MARK: - Episodes Response
struct RMEpisodesResponse: Codable {
    let info: RMInfoResponse
    let results: [RMEpisode]
}

// MARK: - Episode Model
struct RMEpisode: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String // "S01E01"
    let characters: [String]
    let url: String
    let created: String
    
    // Computed property to get season and episode code
    var seasonEpisode: String {
        episode
    }
    
    // Computed property to format the air date
    var formattedDate: String {
        air_date
    }
}
