//
//  RickAndMortyWatchApp.swift
//  RickAndMortyWatch Watch App
//
//  Main app entry point
//

import SwiftUI

@main
struct RickAndMortyWatch_Watch_AppApp: App {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesManager)
        }
    }
}
