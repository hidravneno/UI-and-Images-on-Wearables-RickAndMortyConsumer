# Rick and Morty watchOS App

A Rick and Morty themed watchOS app built with SwiftUI that consumes the public Rick and Morty API.

## Features

### 🎭 Browse Characters
- View a list of all Rick and Morty characters
- See character images, status, and species
- Tap to view detailed character information
- Load more characters with pagination

### 📺 Browse Episodes
- Browse all Rick and Morty episodes
- View episode details including air date and character count
- Navigate through episodes with pagination

### ⭐ Favorites
- Save favorite characters and episodes locally
- Quick access to your favorites
- Persistent storage using UserDefaults

### 🚀 Performance Optimizations
- **Image Caching**: Efficient memory and disk caching for character images
- **Data Caching**: URL request caching for API responses
- **Async/Await**: Modern Swift concurrency for smooth performance

### 🎨 watchOS Optimized UI
- SwiftUI-based interface designed for Apple Watch
- Haptic feedback on favorite actions
- Status indicators with color coding (Green: Alive, Red: Dead, Gray: Unknown)
- Smooth animations and transitions
- Tab-based navigation between Characters, Episodes, and Favorites

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **Async/Await**: For network requests
- **ObservableObject**: For state management

### Data Models
- `Character`: Complete character information from the API
- `Episode`: Episode details including air date and characters
- `Favorite`: Local storage model for favorites

### Services
- `APIService`: Handles all network requests to the Rick and Morty API
- `ImageCache`: In-memory image caching system
- `FavoritesManager`: Manages local favorite storage

### API Integration
Uses the [Rick and Morty API](https://rickandmortyapi.com/) for:
- Character data
- Episode information
- Character images

## Requirements
- watchOS 9.0+
- Xcode 15.0+
- Swift 5.9+

## Installation
1. Clone the repository
2. Open `RickAndMortyWatch.xcodeproj` in Xcode
3. Select a watchOS simulator or device
4. Build and run

## Project Structure
```
RickAndMortyWatch Watch App/
├── RickAndMortyWatchApp.swift       # App entry point
├── ContentView.swift                 # Main navigation view
├── Models.swift                      # Data models
├── APIService.swift                  # Network service
├── ImageCache.swift                  # Image caching
├── FavoritesManager.swift           # Favorites storage
├── CharactersView.swift             # Characters list
├── CharacterDetailView.swift        # Character details
├── EpisodesView.swift               # Episodes list
├── EpisodeDetailView.swift          # Episode details
├── FavoritesView.swift              # Favorites view
├── Assets.xcassets/                 # App assets
└── Info.plist                       # App configuration
```

## Screenshots
The app features a clean, intuitive interface optimized for the Apple Watch form factor with easy navigation between characters, episodes, and favorites.

## License
This project is open source and available under the MIT License.