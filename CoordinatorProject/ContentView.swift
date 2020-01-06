//
//  ContentView.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import SwiftUI
import Combine

enum ContentViewStep {
    case nextIsPicked
}

final class ContentViewModel: ObservableObject, Stepper {
    let stepper = PassthroughSubject<ContentViewStep, Never>()
    
    @Published var titleText: String = ""
    
    init(screenNumber: Int) {
        titleText = "Screen \(screenNumber)"
    }
    
    func onNextButtonTap() {
        stepper.send(.nextIsPicked)
    }
}

struct ContentView: View {
    
    @ObservedObject private var viewModel: ContentViewModel
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.titleText)
        
            Button(action: { self.viewModel.onNextButtonTap() }) {
                Text("Next")
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
