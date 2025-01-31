//
//  RecipeCellView.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation
import SwiftUI

struct RecipeCellView: View {
    
    @StateObject var viewModel: RecipeCellViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.name)
                .padding()
            Spacer()
            Text(viewModel.flag)
                .padding()
            viewModel.image
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        }
        .frame(height: 100.0)
    }
}
