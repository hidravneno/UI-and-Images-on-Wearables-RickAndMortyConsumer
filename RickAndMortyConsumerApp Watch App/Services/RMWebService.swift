//
//  RMWebService.swift
//  RickAndMortyConsumerApp
//
//  Created by francisco eduardo aramburo reyes on 02/12/25.
//

import Foundation

struct RMWebService {
    
    static var hostName: String = "https://rickandmortyapi.com/api/" // -> URL
    
    static func fetchRMCharacters(page: Int) async throws -> RMCharactersResponse {
        var charactersEndpoint = "characters"
        
        guard let url = URL(string: "\(RMWebService.hostName)\(charactersEndpoint)?page=\(page)") else {
            throw fatalError("Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw fatalError("Something Went Wrong")
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw fatalError("Something Went Wrong While Getting The Data")
        }
        
        do {
            // we want to get from response string to an array of RMCharacters
            return try JSONDecoder().decode(RMCharactersResponse.self, from: data)
        } catch {
            
            // you can add retry logic
            // you can add delays
        }
    }
}
