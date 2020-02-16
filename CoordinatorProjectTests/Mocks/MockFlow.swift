//
//  MockFlow.swift
//  CoordinatorProjectTests
//
//  Created by Paul Meyerle on 1/6/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
@testable import CoordinatorProject

//final class MockFlow<Step, Result>: Flow {
//    let presentable: Presentable
//    let rootViewController: UIViewController & Presentable
//    
//    let onCompletionSubject = PassthroughSubject<Result, Never>()
//    var onCompletion: AnyPublisher<Result, Never> {
//        onCompletionSubject.eraseToAnyPublisher()
//    }
//    
//    var children = [AnyHashable : Any]()
//    
//    init(presentable: Presentable = MockPresentable()) {
//        self.presentable = presentable
//    }
//    
//    private(set) var handleCallCount: Int = 0
//    private(set) var handleParamStep = [Step]()
//    func handle(step: Step) {
//        handleCallCount += 1
//        handleParamStep.append(step)
//    }
//}
