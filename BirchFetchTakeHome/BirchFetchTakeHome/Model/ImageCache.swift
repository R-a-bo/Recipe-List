//
//  ImageCache.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/27/25.
//

import Foundation
import OSLog
import SwiftUI

enum ImageSize {
    case small
    case large
}

protocol ImageCaching {
    func getImage(uuid: UUID, imageSize: ImageSize) async -> Image?
    func saveImage(uuid: UUID, imageSize: ImageSize, imageData: Data) async
}

// Rudimentary memory + disk cache. Thread safe. Does not invalidate and refresh data
actor ImageCache: ImageCaching {
    
    private class Key: Hashable {
        let uuid: UUID
        let imageSize: ImageSize
        
        var description: String {
            "uuid \(uuid.uuidString), size \(imageSize == .small ? "small" : "large")"
        }
        
        var fileName: String {
            "\(uuid.uuidString)_\(imageSize == .small ? "small" : "large")"
        }
        
        init(uuid: UUID, imageSize: ImageSize) {
            self.uuid = uuid
            self.imageSize = imageSize
        }
        
        // Hashable
        
        static func ==(lhs: Key, rhs: Key) -> Bool {
            lhs.uuid == rhs.uuid && lhs.imageSize == rhs.imageSize
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
            hasher.combine(imageSize)
        }
    }
    
    // Use NSCache for better app memory management
    private let cache = NSCache<Key, UIImage>()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ImageCache")
    
    func getImage(uuid: UUID, imageSize: ImageSize) -> Image? {
        let key = Key(uuid: uuid, imageSize: imageSize)
        // return memory cached image if it is available and fetched
        if let memoryCachedImage = cache.object(forKey: key) {
            logger.info("Image for recipe \(key.description) found cached in memory")
            return Image(uiImage: memoryCachedImage)
        } else if let diskCachedImage = getFromDisk(key: key) {
            // propogate to memory for easier access going forward
            logger.info("Image for recipe \(key.description) found cached on disk")
            cache.setObject(diskCachedImage, forKey: key)
            return Image(uiImage: diskCachedImage)
        } else {
            logger.info("Image for recipe \(key.description) not found in cache")
            return nil
        }
    }
    
    func saveImage(uuid: UUID, imageSize: ImageSize, imageData: Data) {
        let key = Key(uuid: uuid, imageSize: imageSize)
        guard let uiImage = UIImage(data: imageData) else {
            logger.error("Unable to cache image for recipe \(key.description), cannot convert to UIImage")
            return
        }
        cache.setObject(uiImage, forKey: key)
        saveToDisk(key: key, imageData: imageData)
    }
    
    private func getFromDisk(key: Key) -> UIImage? {
        let url = URL.documentsDirectory.appending(path: key.fileName)
        if let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return nil
    }
    
    private func saveToDisk(key: Key, imageData: Data) {
        let url = URL.documentsDirectory.appending(path: key.fileName)
        do {
            try imageData.write(to: url)
        } catch {
            logger.error("Unable to save image for recipe \(key.description) to disk. Error: \(error.localizedDescription)")
        }
    }
}
