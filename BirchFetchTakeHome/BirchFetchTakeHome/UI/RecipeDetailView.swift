//
//  RecipeDetailView.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/30/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                viewModel.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Text(viewModel.name)
                    .font(.system(size: 30.0))
                if let flag = viewModel.cuisine {
                    Text("Cuisine of origin: \(flag)")
                }
                if viewModel.showSourceLink {
                    Button("See recipe") {
                        viewModel.launchSourceLink()
                    }
                    .buttonStyle(.bordered)
                }
                if viewModel.showYoutubeLink {
                    Button("See how to make recipe on Youtube") {
                        viewModel.launchYoutubeLink()
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
        }
    }
}
