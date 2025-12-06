//
//  ImageCache.swift
//  RickAndMortyWatch Watch App
//
//  Image caching system for performance
//

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    
    private var cache: [String: Data] = [:]
    private let cacheQueue = DispatchQueue(label: "com.rickandmorty.imagecache")
    
    private init() {}
    
    func get(_ key: String) -> Data? {
        cacheQueue.sync {
            return cache[key]
        }
    }
    
    func set(_ key: String, data: Data) {
        cacheQueue.async {
            self.cache[key] = data
        }
    }
    
    func clear() {
        cacheQueue.async {
            self.cache.removeAll()
        }
    }
}

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func load() async {
        // Check cache first
        if let cachedData = ImageCache.shared.get(urlString),
           let cachedImage = UIImage(data: cachedData) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        
        do {
            let data = try await APIService.shared.loadImage(from: urlString)
            ImageCache.shared.set(urlString, data: data)
            
            if let loadedImage = UIImage(data: data) {
                self.image = loadedImage
            }
        } catch {
            print("Error loading image: \(error)")
        }
        
        isLoading = false
    }
}

struct CachedAsyncImage: View {
    let url: String
    let placeholder: Image
    
    @StateObject private var loader: ImageLoader
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
        _loader = StateObject(wrappedValue: ImageLoader(urlString: url))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loader.isLoading {
                ProgressView()
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
        .task {
            await loader.load()
        }
    }
}
