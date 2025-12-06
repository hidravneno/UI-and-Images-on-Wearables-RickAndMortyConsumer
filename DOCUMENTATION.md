# Rick and Morty watchOS App - Technical Documentation

## Overview
This is a native watchOS application built with SwiftUI that provides an immersive Rick and Morty experience on Apple Watch. The app leverages the public Rick and Morty API to display characters and episodes with full offline favorites support.

## Key Features

### 1. Character Browsing
- **List View**: Displays characters with circular avatars and status indicators
- **Status Colors**: 
  - 🟢 Green border = Alive
  - 🔴 Red border = Dead
  - ⚪ Gray border = Unknown
- **Pagination**: "Load More" button to fetch additional characters
- **Favorites**: Star icon indicates saved favorites

### 2. Episode Browsing
- **Episode List**: Shows episode code (e.g., S01E01), name, and air date
- **Episode Details**: Full episode information with character count
- **Pagination**: Seamless loading of more episodes

### 3. Favorites System
- **Local Persistence**: Favorites saved using UserDefaults
- **Mixed Content**: View both favorite characters and episodes
- **Quick Access**: Dedicated favorites tab for easy access
- **Haptic Feedback**: Notification haptic when toggling favorites

### 4. Performance Features
- **Image Caching**: Two-tier caching system
  - In-memory cache for fast access
  - URL cache for reduced network calls
- **API Response Caching**: URLCache configuration for API responses
- **Async/Await**: Modern Swift concurrency for non-blocking UI

## Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel pattern:

```
Models.swift          → Data structures
APIService.swift      → Network layer (ViewModel support)
FavoritesManager.swift → State management (ViewModel)
*View.swift files     → SwiftUI Views
```

### Data Flow
1. **API Request**: View triggers data fetch
2. **Network Call**: APIService makes async request
3. **Response**: Data decoded into Swift structs
4. **Cache Update**: Images and responses cached
5. **UI Update**: @Published properties update views

## File Structure

### Core Files
- **RickAndMortyWatchApp.swift**: App entry point with @main attribute
- **ContentView.swift**: Tab-based navigation container

### Data Layer
- **Models.swift**: Codable structs for API responses
  - Character, Episode, Location, Favorite
  - Response wrapper types
- **APIService.swift**: Singleton service for API calls
  - Generic fetch method
  - Specialized character/episode methods
  - Image loading with caching

### Storage Layer
- **FavoritesManager.swift**: ObservableObject for favorites
  - UserDefaults persistence
  - Character/Episode toggle methods
  - Favorite ID retrieval

### Caching Layer
- **ImageCache.swift**: Custom image cache
  - Thread-safe dictionary cache
  - ImageLoader ObservableObject
  - CachedAsyncImage view component

### View Layer
- **CharactersView.swift**: Character list with pagination
- **CharacterDetailView.swift**: Detailed character info
- **EpisodesView.swift**: Episode list with pagination
- **EpisodeDetailView.swift**: Detailed episode info
- **FavoritesView.swift**: Combined favorites display

## API Integration

### Base URL
```
https://rickandmortyapi.com/api
```

### Endpoints Used
1. **GET /character**: List characters (paginated)
2. **GET /character/:id**: Single character
3. **GET /character?name={name}**: Search characters
4. **GET /episode**: List episodes (paginated)
5. **GET /episode/:id**: Single episode

### Response Format
All responses follow the same structure:
```json
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://...",
    "prev": null
  },
  "results": [...]
}
```

## User Interface

### Navigation Structure
```
TabView
├── CharactersView (Page 1)
│   └── CharacterDetailView
├── EpisodesView (Page 2)
│   └── EpisodeDetailView
└── FavoritesView (Page 3)
    ├── CharacterDetailView
    └── EpisodeDetailView
```

### Color Scheme
- **Characters**: Green accent
- **Episodes**: Blue accent
- **Favorites**: Yellow stars
- **Status**: Context-aware (green/red/gray)

### Animations
- **Favorite Toggle**: Scale + opacity animation
- **Loading States**: ProgressView with color tinting
- **Transitions**: Smooth navigation animations

## Performance Optimizations

### 1. Image Caching
```swift
// Two-level caching
- In-memory dictionary cache
- URL cache (50MB memory, 100MB disk)
```

### 2. Lazy Loading
- Views only load data when needed
- `.task` modifier for async loading
- Pagination for large datasets

### 3. Error Handling
- Graceful error states with retry
- User-friendly error messages
- Network failure recovery

## Building and Running

### Requirements
- macOS 14.0+ (for Xcode 15)
- Xcode 15.0+
- watchOS 9.0+ SDK

### Build Steps
1. Open `RickAndMortyWatch.xcodeproj`
2. Select "RickAndMortyWatch Watch App" scheme
3. Choose a watchOS Simulator or connected device
4. Press Cmd+R to build and run

### Simulator Options
- Apple Watch Series 9 (45mm)
- Apple Watch Ultra
- Apple Watch SE (40mm/44mm)

## Testing Recommendations

### Manual Testing Checklist
- [ ] Browse characters list
- [ ] View character details
- [ ] Add/remove character favorites
- [ ] Browse episodes list
- [ ] View episode details
- [ ] Add/remove episode favorites
- [ ] Check favorites persistence (restart app)
- [ ] Test pagination (load more)
- [ ] Verify image caching (airplane mode)
- [ ] Test error states (network off)

### Edge Cases
- Empty favorites state
- Network timeout
- Invalid image URLs
- Page navigation boundaries

## Future Enhancements

### Potential Features
1. **Search**: Add character/episode search
2. **Filters**: Filter by status, species, etc.
3. **Locations**: Add locations browsing
4. **Watch Complications**: Show random character
5. **Offline Mode**: Full data persistence
6. **Share**: Share characters via Messages

### Technical Improvements
1. **Unit Tests**: Add test coverage
2. **UI Tests**: Automated UI testing
3. **SwiftData**: Replace UserDefaults
4. **Combine**: Enhanced reactive programming
5. **Analytics**: Track user interactions

## Troubleshooting

### Common Issues

**Issue**: Images not loading
- **Solution**: Check network connection, verify API is accessible

**Issue**: Favorites not persisting
- **Solution**: Check UserDefaults permissions, verify app hasn't been deleted

**Issue**: Build errors
- **Solution**: Clean build folder (Cmd+Shift+K), restart Xcode

**Issue**: Simulator crash
- **Solution**: Reset simulator, try different device size

## API Reference

### Rick and Morty API
- **Documentation**: https://rickandmortyapi.com/documentation
- **Rate Limiting**: None
- **Authentication**: Not required
- **HTTPS**: Required (App Transport Security)

## License
MIT License - See LICENSE file for details

## Contributors
Built with ❤️ for Rick and Morty fans and watchOS developers

---
*Get schwifty! 🚀*
