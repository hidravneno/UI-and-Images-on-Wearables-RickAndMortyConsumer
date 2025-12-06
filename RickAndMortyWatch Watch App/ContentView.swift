//
//  ContentView.swift
//  RickAndMortyWatch Watch App
//
//  Main content view with navigation
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CharactersView()
                .tag(0)
            
            EpisodesView()
                .tag(1)
            
            FavoritesView()
                .tag(2)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesManager.shared)
}
