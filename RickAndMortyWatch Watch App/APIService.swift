//
//  APIService.swift
//  RickAndMortyWatch Watch App
//
//  Service for fetching data from Rick and Morty API
//

import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    
    private let baseURL = "https://rickandmortyapi.com/api"
    private let cache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000)
    
    private init() {
        URLCache.shared = cache
    }
    
    // MARK: - Characters
    func fetchCharacters(page: Int = 1) async throws -> CharacterResponse {
        let url = URL(string: "\(baseURL)/character?page=\(page)")!
        return try await fetch(url: url)
    }
    
    func fetchCharacter(id: Int) async throws -> Character {
        let url = URL(string: "\(baseURL)/character/\(id)")!
        return try await fetch(url: url)
    }
    
    func searchCharacters(name: String) async throws -> CharacterResponse {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let url = URL(string: "\(baseURL)/character?name=\(encodedName)")!
        return try await fetch(url: url)
    }
    
    // MARK: - Episodes
    func fetchEpisodes(page: Int = 1) async throws -> EpisodeResponse {
        let url = URL(string: "\(baseURL)/episode?page=\(page)")!
        return try await fetch(url: url)
    }
    
    func fetchEpisode(id: Int) async throws -> Episode {
        let url = URL(string: "\(baseURL)/episode/\(id)")!
        return try await fetch(url: url)
    }
    
    // MARK: - Generic Fetch
    private func fetch<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - Image Loading
    func loadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return data
    }
}

// MARK: - API Error
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
