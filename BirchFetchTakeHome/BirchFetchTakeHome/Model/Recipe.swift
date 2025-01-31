//
//  Recipe.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation

struct Recipe {
    
    let cuisine: Locale.Region?
    let name: String
    let photoUrlLarge: URL
    let photoUrlSmall: URL
    let uuid: UUID
    let youtubeUrl: URL?
    
    init?(dto: RecipeDTO) {
        let cuisine = Locale.Region(adjectival: dto.cuisine)
        guard let photoUrlLarge = URL(string: dto.photoUrlLarge) else { return nil }
        guard let photoUrlSmall = URL(string: dto.photoUrlSmall) else { return nil }
        guard let uuid = UUID(uuidString: dto.uuid) else { return nil }
        if let youtubeUrlString = dto.youtubeUrl,
           let youtubeUrl = URL(string: youtubeUrlString) {
            self.youtubeUrl = youtubeUrl
        } else {
            self.youtubeUrl = nil
        }
        
        self.cuisine = cuisine
        self.name = dto.name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.uuid = uuid
    }
}

struct RecipeDTO: Decodable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
}

struct RecipeListDTO: Decodable {
    let recipes: [RecipeDTO]
}
