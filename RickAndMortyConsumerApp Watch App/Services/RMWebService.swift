//
//  RMWebService.swift
//  RickAndMortyConsumerApp Watch App
//

import Foundation

enum RMServiceError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
}

class RMWebService {
    
    static let shared = RMWebService()
    private let baseURL = "https://rickandmortyapi.com/api"
    
    // Cache for responses
    private var charactersCache: [Int: RMCharactersResponse] = [:]
    private var episodesCache: [Int: RMEpisodesResponse] = [:]
    
    private init() {}
    
    // MARK: - Fetch Characters
    func fetchCharacters(page: Int = 1) async throws -> RMCharactersResponse {
        // Check cache first
        if let cached = charactersCache[page] {
            print("📦 Returning cached characters for page \(page)")
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/character?page=\(page)") else {
            throw RMServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RMServiceError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw RMServiceError.invalidResponse
            }
            
            let decoded = try JSONDecoder().decode(RMCharactersResponse.self, from: data)
            
            // Save to cache
            charactersCache[page] = decoded
            print("✅ Fetched and cached characters page \(page)")
            
            return decoded
        } catch let error as DecodingError {
            print("❌ Decoding error: \(error)")
            throw RMServiceError.invalidData
        } catch {
            print("❌ Network error: \(error)")
            throw RMServiceError.networkError(error)
        }
    }
    
    // MARK: - Fetch Single Character
    func fetchCharacter(id: Int) async throws -> RMCharacter {
        guard let url = URL(string: "\(baseURL)/character/\(id)") else {
            throw RMServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw RMServiceError.invalidResponse
            }
            
            let decoded = try JSONDecoder().decode(RMCharacter.self, from: data)
            return decoded
        } catch {
            throw RMServiceError.networkError(error)
        }
    }
    
    // MARK: - Fetch Episodes
    func fetchEpisodes(page: Int = 1) async throws -> RMEpisodesResponse {
        // Check cache first
        if let cached = episodesCache[page] {
            print("📦 Returning cached episodes for page \(page)")
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/episode?page=\(page)") else {
            throw RMServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw RMServiceError.invalidResponse
            }
            
            let decoded = try JSONDecoder().decode(RMEpisodesResponse.self, from: data)
            
            // Save to cache
            episodesCache[page] = decoded
            print("✅ Fetched and cached episodes page \(page)")
            
            return decoded
        } catch let error as DecodingError {
            print("❌ Decoding error: \(error)")
            throw RMServiceError.invalidData
        } catch {
            print("❌ Network error: \(error)")
            throw RMServiceError.networkError(error)
        }
    }
    
    // MARK: - Clear Cache
    func clearCache() {
        charactersCache.removeAll()
        episodesCache.removeAll()
        print("🗑️ Cache cleared")
    }
}
