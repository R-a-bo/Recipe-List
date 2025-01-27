//
//  Recipe.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation

struct Recipe {
    let cuisine: Locale.Region
    let name: String
    let photoUrlLarge: URL
    let photoUrlSmall: URL
    let uuid: UUID
    let youtubeUrl: URL
    
    init?(dto: RecipeDTO) {
        guard let cuisine = Locale.Region(adjectival: dto.cuisine) else { return nil }
        guard let photoUrlLarge = URL(string: dto.photoUrlLarge) else { return nil }
        guard let photoUrlSmall = URL(string: dto.photoUrlSmall) else { return nil }
        guard let uuid = UUID(uuidString: dto.uuid) else { return nil }
        guard let youtubeUrl = URL(string: dto.youtubeUrl) else { return nil }
        
        self.cuisine = cuisine
        self.name = dto.name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.uuid = uuid
        self.youtubeUrl = youtubeUrl
    }
}

struct RecipeDTO: Decodable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String
    let uuid: String
    let youtubeUrl: String
}
