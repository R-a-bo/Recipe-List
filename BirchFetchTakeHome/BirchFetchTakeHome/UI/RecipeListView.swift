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
            List {
                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                    RecipeCellView(viewModel: RecipeCellViewModel(recipe: recipe, imageCache: viewModel.imageCache, network: viewModel.network, delegate: viewModel))
                }
            }
            .alert("Error", isPresented: showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .navigationTitle("Recipes")
        }
//        .navigationdest
    }
}
