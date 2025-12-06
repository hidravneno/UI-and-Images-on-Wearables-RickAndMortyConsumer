//
//  CharactersGridView.swift
//  RickAndMortyConsumerApp
//
//  Created by francisco eduardo aramburo reyes on 02/12/25.
//

import SwiftUI

struct RMCharacters: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

struct CharactersGridView: View {
    private let mockCherecters: [RMCharacters] = [
        RMCharacters(
            name: "Rick Sanchez",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        ),
        RMCharacters(
            name: "Morty Smith",
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
        ),
        RMCharacters(
            name: "Summer Smith",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"
        ),
        RMCharacters(
            name: "Beth Smith",
            image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg"
        ),
    ]

    // Defining Number Of Columns For Grid
    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(mockCherecters) { character in
                    VStack(spacing: 2) {
                        AsyncImage(url: URL(string: character.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            case .empty:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(.secondary.opacity(0.4))
                                    ProgressView()
                                }
                                .frame(width: 70, height: 70)
                            case .failure:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(.secondary.opacity(0.4))
                                    Image(systemName: "photo")
                                        .font(.caption)
                                }
                                .frame(width: 70, height: 70)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        Text(character.name)
                            .font(.system(size: 9))
                            .lineLimit(1)
                    }
                }
            }
            .padding(4)
        }
    }
}

#Preview {
    CharactersGridView()
}
