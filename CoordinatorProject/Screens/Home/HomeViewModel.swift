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
    var eventPublisher: AnyPublisher<HomeViewModelFlowEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    @Published private(set) var optionTitleText: String = ""
    
    func onPresentButtonTap() {
        eventSubject.send(.presentIsPicked)
    }
    
    func onPushButtonTap() {
        eventSubject.send(.pushIsPicked)
    }
    
    func onOptionButtonTap() {
        let event: HomeViewModelFlowEvent = .optionIsRequired { [weak self] (id, name) in
            self?.optionTitleText = "id: \(id), name: \(name)"
        }
        
        eventSubject.send(event)
    }
}
