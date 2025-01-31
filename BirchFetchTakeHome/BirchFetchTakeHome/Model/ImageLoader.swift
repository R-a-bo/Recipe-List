//
//  ImageLoader.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/29/25.
//

import Foundation
import OSLog
import SwiftUI

protocol ImageLoading {
    func loadImage() async throws -> Image
}

class ImageLoader {
    
    private let uuid: UUID
    private let imageSize: ImageSize
    private let imageUrl: URL
    
    private let cache: ImageCaching
    private let network: Networking
    
    private var fetchTask: Task<Data, Error>?
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ImageLoader")
    
    init(uuid: UUID, imageSize: ImageSize, imageUrl: URL, cache: ImageCaching, network: Networking) {
        self.uuid = uuid
        self.imageSize = imageSize
        self.imageUrl = imageUrl
        
        self.cache = cache
        self.network = network
        
        self.fetchTask = nil
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    func loadImage() async throws -> Image {
        if let image = await cache.getImage(uuid: uuid, imageSize: imageSize) {
            return image
        } else {
            fetchTask = Task {
                try await network.getImage(imageUrl: imageUrl)
            }
            let imageData = try await fetchTask!.value
            Task {
                await cache.saveImage(uuid: uuid, imageSize: imageSize, imageData: imageData)
            }
            guard let uiImage = UIImage(data: imageData) else {
                throw RecipeListError.invalidData
            }
            return Image(uiImage: uiImage)
        }
    }
}
