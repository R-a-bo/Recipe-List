//
//  RecipeCellViewModel.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/27/25.
//

import OSLog
import SwiftUI

protocol RecipeCellViewModelDelegate: AnyObject {
    func recipeCellViewModelDidError(_ recipeCellViewModel: RecipeCellViewModel, message: String)
}

class RecipeCellViewModel: ObservableObject {
    
    @Published var name: String
    @Published var flag: String
    @Published var image: Image
    
    private let imageCache: ImageCaching
    private let network: Networking
    private let recipeUUID: UUID
    private let imageUrl: URL
    
    private let imageLoader: ImageLoader
    
    weak var delegate: RecipeCellViewModelDelegate?
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "RecipeCellViewModel")
    
    init(recipe: Recipe, imageCache: ImageCaching, network: Networking, delegate: RecipeCellViewModelDelegate) {
        self.name = recipe.name
        self.flag = recipe.cuisine?.flagEmoji ?? ""
        self.image = Image("placeholder")
        self.imageCache = imageCache
        self.network = network
        self.delegate = delegate
        self.recipeUUID = recipe.uuid
        self.imageUrl = recipe.photoUrlSmall
        
        self.imageLoader = ImageLoader(uuid: recipeUUID,
                                       imageSize: .small,
                                       imageUrl: imageUrl,
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
                delegate?.recipeCellViewModelDidError(self, message: "Unable to load recipe image: \(error.localizedDescription)")
            }
        }
    }
}
