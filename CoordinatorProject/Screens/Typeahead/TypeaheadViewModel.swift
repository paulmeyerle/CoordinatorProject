//
//  TypeaheadViewModel.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/16/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

final class TypeaheadViewModel: ObservableObject, EventEmitter {
    private let eventSubject = PassthroughSubject<TypeaheadViewModelFlowEvent, Never>()
    var eventPublisher: AnyPublisher<TypeaheadViewModelFlowEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    func onModelSelected(id: Int, name: String) {
        eventSubject.send(.optionPicked(id: id, name: name))
    }
}
