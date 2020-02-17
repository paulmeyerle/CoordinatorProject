//
//  HomeView.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/15/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Select an option")
                .font(.headline)
                .onTapGesture {
                    self.viewModel.onOptionButtonTap()
                }
            
            Text(viewModel.optionTitleText)
                .font(.subheadline)
            
            HStack {
                Button(action: { self.viewModel.onPushButtonTap() }) {
                    Text("Push Content Flow")
                }
                
                Divider()
                
                Button(action: { self.viewModel.onPresentButtonTap() }) {
                    Text("Present Content Flow")
                }
            }
            .frame(height: 50)
        }
        .navigationBarTitle("Home")
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
