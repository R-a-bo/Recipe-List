//
//  Network.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import SwiftUI

protocol Networking {
    
    func getRecipeList(recipesUrl: URL) async throws -> [Recipe]
    func getImage(imageUrl: URL) async throws -> Data
}

class Network: Networking {
    
    func getRecipeList(recipesUrl: URL) async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: recipesUrl)
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let recipesDto = try jsonDecoder.decode(RecipeListDTO.self, from: data)
        return try recipesDto.recipes.map {
            guard let recipe = Recipe(dto: $0) else {
                throw RecipeListError.invalidData
            }
            return recipe
        }
    }
    
    func getImage(imageUrl: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        return data
    }
}
