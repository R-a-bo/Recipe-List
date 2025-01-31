//
//  RecipeListViewModel.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation
import OSLog

class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe]
    @Published var errorMessage: String?
    let imageCache: ImageCaching
    let network: Networking
    
    private static let recipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "RecipeListViewModel")
    
    init(imageCache: ImageCaching, network: Networking) {
        self.recipes = []
        self.imageCache = imageCache
        self.network = network
        
        getRecipes()
    }
    
    private func getRecipes() {
        Task { @MainActor in
            do {
                guard let recipesUrl = URL(string: Self.recipesUrlString) else {
                    logger.error("Invalid recipe list URL")
                    throw RecipeListError.invalidUrl
                }
                let fetchedRecipes = try await network.getRecipeList(recipesUrl: recipesUrl)
                self.recipes = fetchedRecipes
            } catch {
                logger.error("Displaying error alert for error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

extension RecipeListViewModel: RecipeCellViewModelDelegate {
    
    func recipeCellViewModelDidError(_ recipeCellViewModel: RecipeCellViewModel, message: String) {
        self.errorMessage = message
    }
}
