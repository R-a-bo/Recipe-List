//
//  RecipeDetailViewModel.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/30/25.
//

import OSLog
import SwiftUI

class RecipeDetailViewModel: ObservableObject {
    
    @Published var image: Image
    @Published var name: String
    @Published var cuisine: String?
    @Published var showSourceLink: Bool
    @Published var showYoutubeLink: Bool
    @Published var errorMessage: String?
    
    private let recipe: Recipe
    private let imageCache: ImageCaching
    private let network: Networking
    private let imageLoader: ImageLoader
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "RecipeDetailViewModel")
    
    init(recipe: Recipe, imageCache: ImageCaching, network: Networking) {
        self.recipe = recipe
        self.imageCache = imageCache
        self.network = network
        
        self.image = Image("placeholder")
        self.name = recipe.name
        self.cuisine = recipe.cuisine?.flagEmoji
        self.showSourceLink = recipe.sourceUrl != nil
        self.showYoutubeLink = recipe.youtubeUrl != nil
        
        self.imageLoader = ImageLoader(uuid: recipe.uuid,
                                       imageSize: .large,
                                       imageUrl: recipe.photoUrlLarge,
                                       cache: imageCache,
                                       network: network)
        
        getRecipeImage()
    }
    
    private func getRecipeImage() {
        Task { @MainActor in
            do {
                let fetchedImage = try await imageLoader.loadImage()
                self.image = fetchedImage
            } catch {
                logger.error("Unable to fetch small image for recipe \(self.name). Error: \(error.localizedDescription)")
                self.errorMessage = "Unable to load recipe image: \(error.localizedDescription)"
            }
        }
    }
    
    func launchSourceLink() {
        guard let sourceUrl = recipe.sourceUrl else { return }
        UIApplication.shared.open(sourceUrl)
    }
    
    func launchYoutubeLink() {
        guard let youtubeUrl = recipe.youtubeUrl else { return }
        UIApplication.shared.open(youtubeUrl)
    }
}
