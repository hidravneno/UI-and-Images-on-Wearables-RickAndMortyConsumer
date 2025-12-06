//
//  Model.swift
//  RickAndMortyConsumerApp
//
//  Created by francisco eduardo aramburo reyes on 02/12/25.
//

import Foundation

struct RMCharactersResponse {
    let results: [RMCharacter]
    let info: RMInfoResponse
}

struct RMInfoResponse {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct RMCharacter: Identifiable {
    let id: Int
    let name: String
    let image: String
}
