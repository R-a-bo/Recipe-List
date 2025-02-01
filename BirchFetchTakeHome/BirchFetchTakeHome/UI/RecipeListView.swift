//
//  RecipeListView.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel: RecipeListViewModel
    
    private var showError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
    
    var body: some View {
        NavigationStack {
            if !viewModel.recipes.isEmpty {
                List {
                    ForEach(viewModel.recipes, id: \.uuid) { recipe in
                        NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe,
                                                                                                      imageCache: viewModel.imageCache,
                                                                                                      network: viewModel.network))) {
                            RecipeCellView(viewModel: RecipeCellViewModel(recipe: recipe, imageCache: viewModel.imageCache, network: viewModel.network, delegate: viewModel))
                        }
                    }
                }
                .navigationTitle("Recipes")
            } else {
                Text("No recipes found")
            }
        }
        .alert("Error", isPresented: showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
