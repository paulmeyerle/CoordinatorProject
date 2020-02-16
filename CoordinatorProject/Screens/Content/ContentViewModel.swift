//
//  ContentViewModel.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/16/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

final class ContentViewModel: ObservableObject, EventEmitter {
    
    let eventSubject = PassthroughSubject<ContentViewModelFlowEvent, Never>()
    var stepper: AnyPublisher<ContentViewModelFlowEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    @Published var titleText: String = ""
    @Published var subtitleText: String = ""
    
    init(title: String, screenNumber: Int) {
        titleText = title
        subtitleText = "Screen \(screenNumber)"
    }
    
    func onNextButtonTap() {
        eventSubject.send(.nextIsPicked)
    }
}
