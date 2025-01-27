//
//  ImageCache.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/27/25.
//

import Foundation
import SwiftUI

class ImageCache {
    
    enum ImageSize {
        case small
        case large
    }
    
    private class Key: Hashable {
        let uuid: UUID
        let imageSize: ImageSize
        
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
    
    private class Entry {
        let image: Image
        let lastFetched: Date
        
        init(image: Image, lastFetched: Date) {
            self.image = image
            self.lastFetched = lastFetched
        }
    }
    
    private let network: Networking
    
    // Use NSCache for better app memory management
    private let cache = NSCache<Key, Entry>()
    
    // Keep track of Tasks to avoid creating duplicate tasks
    private var tasks = [Key: Task<Image, Error>]()
    
    init(network: Networking) {
        self.network = network
    }
    
    // In a simple app like this, we can always call this function from the main thread,
    //      thus avoiding concurrency issues such a data races that could occur if the cache
    //      or tasks dict were accessed from different thread simultaneously
    func getImage(uuid: UUID, url: URL, imageSize: ImageSize) -> Task<Image, Error> {
        let key = Key(uuid: uuid, imageSize: imageSize)
        // Acept cached entry only if it was made less than 24 hours ago
        if let entry = cache.object(forKey: key),
           entry.lastFetched.addingTimeInterval(24 * 60 * 60) > Date.now {
            return Task { return entry.image }
        } else if let task = tasks[key] {
            return task
        } else {
            return Task {
                return try await network.getImage(imageUrl: url)
            }
        }
    }
}
