//
//  ContentView.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject private var viewModel: ContentViewModel
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.subtitleText)
                .font(.body)
        
            Button(action: { self.viewModel.onNextButtonTap() }) {
                Text("Next")
            }
        }
        .navigationBarTitle(viewModel.titleText)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
