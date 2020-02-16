//
//  StepStore.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/15/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

public final class StepStore {
    
    private let countSubject = PassthroughSubject<Int, Never>()
    
    public var isEmptyPublisher: AnyPublisher<Void, Never> {
        countSubject
            .filter { $0 == 0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    private var store = [AnyHashable: Any]() {
        didSet {
            countSubject.send(store.count)
        }
    }
    
    subscript(index: AnyHashable) -> Any? {
        get {
            return store[index]
        }
        set(newValue) {
            store[index] = newValue
        }
    }
}
