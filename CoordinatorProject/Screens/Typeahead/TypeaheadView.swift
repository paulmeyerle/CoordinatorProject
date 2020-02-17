//
//  TypeaheadView.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/16/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import SwiftUI

struct TypeaheadView: View {
    
    @ObservedObject private var viewModel: TypeaheadViewModel
    
    init(viewModel: TypeaheadViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Option One: 1")
                .onTapGesture {
                    self.viewModel.onModelSelected(id: 1, name: "Option One")
                }
            Divider()
            Text("Option Two: 2")
                .onTapGesture {
                    self.viewModel.onModelSelected(id: 2, name: "Option Two")
                }
            Divider()
            Text("Option Three: 3")
                .onTapGesture {
                    self.viewModel.onModelSelected(id: 3, name: "Option Three")
                }
        }
    }
}

//struct TypeaheadView_Previews: PreviewProvider {
//    static var previews: some View {
//        TypeaheadView()
//    }
//}
