//
//  ImageCache.swift
//  RickAndMortyWatch Watch App
//
//  Image caching system for performance
//

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        // Configure cache limits for watchOS
        cache.countLimit = 100  // Maximum 100 images
        cache.totalCostLimit = 50_000_000  // 50MB limit
    }
    
    func get(_ key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    func set(_ key: String, data: Data) {
        let nsData = data as NSData
        cache.setObject(nsData, forKey: key as NSString, cost: data.count)
    }
    
    func clear() {
        cache.removeAllObjects()
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
