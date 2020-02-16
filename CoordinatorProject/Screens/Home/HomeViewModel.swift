//
//  HomeViewModel.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/16/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

final class HomeViewModel: ObservableObject, EventEmitter {
    private let eventSubject = PassthroughSubject<HomeViewModelFlowEvent, Never>()
    var stepper: AnyPublisher<HomeViewModelFlowEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func onPresentButtonTap() {
        eventSubject.send(.presentIsPicked)
    }
    
    func onPushButtonTap() {
        eventSubject.send(.pushIsPicked)
    }
}
