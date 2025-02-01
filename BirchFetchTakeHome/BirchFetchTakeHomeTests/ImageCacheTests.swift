//
//  ImageCacheTests.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/31/25.
//

@testable import BirchFetchTakeHome
import XCTest

final class ImageCacheTests: XCTestCase {
    
    private let imageCache = ImageCache()
    
    func testSaveRetrieveImage() async {
        let dataAsset = NSDataAsset(name: "sample_recipe_image")
        XCTAssertNotNil(dataAsset, "Cannot retrieve sample recipe image")
        guard let dataAsset else { return }
        let imageData = dataAsset.data
        let uuid = UUID()
        await imageCache.saveImage(uuid: uuid, imageSize: .small, imageData: imageData)
        let retrievedImage = await imageCache.getImage(uuid: uuid, imageSize: .small)
        XCTAssertNotNil(retrievedImage, "Cached image unable to be retrieved")
    }
}
