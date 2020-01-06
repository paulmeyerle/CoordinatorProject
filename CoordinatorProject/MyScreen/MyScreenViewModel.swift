//
//  MyScreenViewModel.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

enum MyScreenViewEvent: Step {
    case nextIsPicked
}

final class MyScreenViewModel: Stepper {
    let stepper = PassthroughSubject<MyScreenViewEvent, Never>()
    
    let titleText: String
    
    init(screenNumber: Int) {
        titleText = "Screen \(screenNumber)"
        
         print("MyScreenViewModel - init")
    }
    
    deinit {
         print("MyScreenViewModel - deinit")
    }
    
    func onButtonTap() {
        print("nextIsPicked")
        stepper.send(.nextIsPicked)
    }
}
