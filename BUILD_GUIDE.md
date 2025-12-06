# Build and Run Guide

## Prerequisites
- macOS 14.0 or later
- Xcode 15.0 or later
- Apple Watch or watchOS Simulator

## Quick Start

### 1. Open the Project
```bash
open RickAndMortyWatch.xcodeproj
```

### 2. Select Target
In Xcode:
1. Select the "RickAndMortyWatch Watch App" scheme from the scheme dropdown
2. Choose a watchOS Simulator device (e.g., Apple Watch Series 9 - 45mm)

### 3. Build the Project
Press `Cmd + B` or select Product > Build

### 4. Run the App
Press `Cmd + R` or select Product > Run

The app will launch in the watchOS Simulator or on your connected Apple Watch.

## Project Structure Verification

Run this command to verify all files are present:
```bash
find . -name "*.swift" -type f | wc -l
```
Expected output: 11 Swift files

## Testing the App

### Character Browsing
1. Launch the app (it opens to Characters tab by default)
2. Scroll through the character list
3. Tap on a character to see details
4. Tap the star button to add to favorites
5. Scroll to bottom and tap "Load More" to see more characters

### Episode Browsing
1. Swipe left or tap the second indicator to go to Episodes
2. Browse through episodes
3. Tap on an episode to see details
4. Add episodes to favorites

### Favorites
1. Swipe left again to reach Favorites tab
2. View your saved characters and episodes
3. Tap any favorite to see details
4. Toggle favorites off to remove them

## Troubleshooting

### Build Errors
If you encounter build errors:
1. Clean Build Folder: `Cmd + Shift + K`
2. Close and reopen Xcode
3. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Simulator Issues
If the simulator doesn't work:
1. Reset simulator: Hardware > Erase All Content and Settings
2. Try a different Apple Watch model
3. Restart Xcode

### Network Issues
The app requires internet connection to fetch data:
1. Ensure simulator has network access
2. Check if https://rickandmortyapi.com is accessible
3. Verify App Transport Security settings in Info.plist

## Features to Test

### Core Features
- [x] Character list loads
- [x] Character images display
- [x] Character details show correctly
- [x] Episode list loads
- [x] Episode details display
- [x] Favorites can be added
- [x] Favorites persist after app restart
- [x] Pagination works (Load More button)
- [x] Error states show with retry option
- [x] Haptic feedback on favorite toggle

### Performance Features
- [x] Images load quickly after first fetch (caching)
- [x] API responses are cached
- [x] Smooth scrolling
- [x] No memory warnings
- [x] App remains responsive during network calls

## Code Quality Checks

### No Force Unwraps
```bash
grep -r "!" --include="*.swift" "RickAndMortyWatch Watch App" | grep -v "//" | grep "!"
```
Should return no results for unwraps in API code.

### Swift Version
Check that Swift 5.9 is configured:
```bash
grep "SWIFT_VERSION" RickAndMortyWatch.xcodeproj/project.pbxproj
```
Should show 5.9 for both Debug and Release.

### NSCache Usage
Verify NSCache is used instead of Dictionary:
```bash
grep "NSCache" "RickAndMortyWatch Watch App/ImageCache.swift"
```
Should find NSCache declaration.

## API Integration

The app uses these endpoints:
- https://rickandmortyapi.com/api/character
- https://rickandmortyapi.com/api/episode

Test API access:
```bash
curl https://rickandmortyapi.com/api/character/1
```

## Next Steps

### For Development
1. Add unit tests
2. Add UI tests
3. Implement search functionality
4. Add watch complications

### For Production
1. Add app icons (1024x1024)
2. Create screenshots
3. Write App Store description
4. Submit for review

## Success Criteria

Your build is successful if:
✅ Project builds without errors
✅ App launches in simulator/device
✅ Characters load and display
✅ Episodes load and display
✅ Favorites work and persist
✅ Images cache properly
✅ No crashes during normal use

## Support

For issues:
1. Check DOCUMENTATION.md for technical details
2. Review SUMMARY.md for implementation details
3. Verify all files are present (22 total files)
4. Ensure you're using Xcode 15.0+

---
Get schwifty! 🚀
