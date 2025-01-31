//
//  BirchFetchTakeHomeApp.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import SwiftUI

@main
struct BirchFetchTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel(imageCache: ImageCache(), network: Network()))
        }
    }
}
